class FollowValidator < ActiveModel::Validator
  def validate(record)
    if record.followee_id == record.follower_id
      record.errors.add :follower, "You cannot follow yourself!"
    end
  end
end

class Follow < ApplicationRecord
  validates_with FollowValidator

  belongs_to :follower, foreign_key: "follower_id", class_name: "User"
  belongs_to :followee, foreign_key: "followee_id", class_name: "User"
end
