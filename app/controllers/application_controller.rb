require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    begin
      flash[:alert] = exception.message.html_safe
      redirect_back(fallback_location: root_path)
    rescue ActionController::RedirectBackError
      redirect_to courses_path, :alert => exception.message.html_safe
    end
  end

  def after_sign_in_path_for(resource)
    courses_path
  end
end
