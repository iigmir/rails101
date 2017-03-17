class Group < ApplicationRecord
  belongs_to :user
  has_many :posts
  validates :title, presence: true
  has_many :group_rels
  has_many :members, through: :group_rels, source: :user
end
