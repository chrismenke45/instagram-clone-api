class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { in: 3..30 }
  validates :username, presence: true, uniqueness: true, length: { in: 3..30 }
  validates :bio, length: { maximum: 2200 }
  validates :profile_picture, presence: true
  validates :password_digest, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
