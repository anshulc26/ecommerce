class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def check_email_unique
    email = params.dig(:user, :email)

    if email.present?
      render json: !User.exists?(email: email)
    else
      render json: true
    end
  end
end
