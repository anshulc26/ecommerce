FactoryBot.define do
  factory :product do
    association :user
    name { FFaker::Lorem.word }
    sku { FFaker::Product.model }
    price { 100 }
    quantity { 1000 }
  end
end
