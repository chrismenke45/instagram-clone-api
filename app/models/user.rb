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

  # follower_follows "names" the Follow join table for accessing through the follower association
  has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow", dependent: :destroy
  # source: :follower matches with the belong_to :follower identification in the Follow model
  has_many :followers, through: :follower_follows, source: :follower

  # followee_follows "names" the Follow join table for accessing through the followee association
  has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
  # source: :followee matches with the belong_to :followee identification in the Follow model
  has_many :followees, through: :followee_follows, source: :followee

  has_many :sent_messages, foreign_key: :sender_id, class_name: "Message", dependent: :destroy
  has_many :received_messages, foreign_key: :receiver_id, class_name: "Message", dependent: :destroy
end
