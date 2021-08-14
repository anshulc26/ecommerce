class Product < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user

  validates :user_id, presence: true
  validates :name, :sku, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: true
  validates :quantity, presence: true, numericality: { only_integer: true }

  scope :of_state, ->(state_code) { joins(:user).where(users: { state_code: state_code }) }
end
