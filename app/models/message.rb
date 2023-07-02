class Message < ApplicationRecord
  belongs_to :users
  belongs_to :room

  validates :content, presence:true, length: {maximum: 140}
end
