class AuthenticationsController < ApplicationController
  before_action(only: :new) { redirect_to messages_url if Current.user }

  def new
    authentication = Authentication.restore_submission(authentications_params)

    render locals: { authentication: authentication }
  end

  def create
    authentication = Authentication.new(authentications_params)
    authentication.session = session

    if authentication.save
      redirect_to messages_url
    else
      redirect_to new_authentication_url, params: { authentication: authentications_params.except(:password) }
    end
  end

  def destroy
    authentication = Authentication.new(session: session)

    authentication.destroy

    redirect_back fallback_location: messages_url
  end

  def authentications_params
    params.fetch(:authentication, {}).permit(:username, :password)
  end
end
