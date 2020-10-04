class MessagesController < ApplicationController
  before_action(except: :index) { head :forbidden unless Current.user }

  def create
    message = Current.user.messages.new(message_params)

    if message.save
      redirect_to messages_url
    else
      redirect_to messages_url, params: { message: message_params }
    end
  end

  def index
    messages = Message.all.order(:created_at).with_rich_text_content
    message = Message.restore_submission(message_params)

    render locals: { messages: messages, message: message }
  end

  private

  def message_params
    params.fetch(:message, {}).permit(:content)
  end
end
