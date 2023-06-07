class ApplicationController < ActionController::Base
  before_action :configure_premitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    user_path(resource.id)
  end

  def after_sign_out_path_for(resource)
    about_path
  end

  protected
  def configure_premitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
