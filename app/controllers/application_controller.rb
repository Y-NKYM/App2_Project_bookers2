class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]
  before_action :configure_premitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    flash[:notice] = "Welcome! You have signed up successfully."
    user_path(resource.id)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  protected
  def configure_premitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
