class User < ApplicationRecord
  validates :name, presence: true, length: { in: 3..30 }
  validates :username, presence: true, uniqueness: true, length: { in: 3..30 }
  validates :bio, length: { maximum: 150 }
  validates :profile_picture, presence: true
  validates :hash_password, presence: true, length: { is: 43 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
