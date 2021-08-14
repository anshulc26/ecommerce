class BuyersController < ApplicationController
  before_action :authenticate_buyer!

  protected

  def authenticate_buyer!
    return if current_user.buyer?

    flash[:alert] = t('errors.not_authorized')
    redirect_back fallback_location: root_path
  end
end
