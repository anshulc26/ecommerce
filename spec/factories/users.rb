FactoryBot.define do
  factory :user do
    user_type { "buyer" }
    name { FFaker::Lorem.word }
    email { FFaker::Internet.email }
    password { "password" }
    password_confirmation { password }
    state_code { "AK" }

    factory :seller do
      user_type { "seller" }
    end
  end
end
