module FeatureHelper
  def sign_in(user)
    visit "/users/sign_in"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Log in"
  end
end

RSpec.configure do |config|
  config.include FeatureHelper, type: :feature
end
