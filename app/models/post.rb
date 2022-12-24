class Post < ApplicationRecord
  validates :picture_url, presence: true
  validates :caption, length: { maximum: 2200 }

  has_many :comments

  belongs_to :user
end
