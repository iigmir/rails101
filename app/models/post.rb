class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :content, presence: true
  # scope "recent" will order created date
  scope :recent, -> { order("created_at DESC") }
end
