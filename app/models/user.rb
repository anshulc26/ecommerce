class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  USER_TYPES = %w[buyer seller].freeze
  enum user_type: USER_TYPES

  has_many :products, dependent: :destroy

  validates :user_type, presence: true, inclusion: { in: USER_TYPES }
  validates :name, :state_code, presence: true, length: { maximum: 255 }
end
