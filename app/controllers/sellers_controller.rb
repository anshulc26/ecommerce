class SellersController < ApplicationController
  before_action :authenticate_seller!

  protected

  def authenticate_seller!
    return if current_user.seller?

    flash[:alert] = t('errors.not_authorized')
    redirect_back fallback_location: root_path
  end
end
