class Group < ApplicationRecord
  has_one_attached :group_image
  has_many :group_users
  has_many :users, through: :group_users, dependent: :destroy

  validates: :name, presence: true, uniqueness: true
end
