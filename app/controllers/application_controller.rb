class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    redirect_path(user)
  end

  def after_sign_up_path_for(user)
    redirect_path(user)
  end

  def after_sign_out_path_for(_user)
    new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[user_type name state_code])
  end

  private

  def redirect_path(user)
    return marketplace_path if user.buyer?

    return products_path if user.seller?

    dashboard_path
  end
end
