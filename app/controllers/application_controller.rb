class ApplicationController < ActionController::Base
  include FlashParams

  before_action { Current.user = Authentication.find(session) }
end
