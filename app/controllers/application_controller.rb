require "./lib/validation_message_form_builder"

class ApplicationController < ActionController::Base
  include FlashParams

  before_action { Current.user = Authentication.find(session) }

  default_form_builder ValidationMessageFormBuilder
end
