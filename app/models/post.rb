class Post < ApplicationRecord
  validates :picture_url, presence: true

  has_many :comments, as: :parent_post

  belongs_to :user
end
