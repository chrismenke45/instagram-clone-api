class Follow < ApplicationRecord
  # belongs_to :follower
  # belongs_to :followee
  belongs_to :follower, foreign_key: "follower_id", class_name: "User"
  belongs_to :followee, foreign_key: "followee_id", class_name: "User"
end
