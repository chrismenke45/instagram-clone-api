class Comment < ApplicationRecord
  validates :text, presence: true, length: { in: 1..255 }

  belongs_to :parent_post, polymorphic: true
  has_many :comments, as: :parent_post

  belongs_to :user
end
