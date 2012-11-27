require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_registration_path, :alert => exception.message
  end
end
