class ApplicationController < ActionController::Base
  before_action :configure_premitted_parameters, if: :devise_controller?

  protected

  def configure_premitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
