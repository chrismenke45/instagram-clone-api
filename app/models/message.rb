class MessageValidator < ActiveModel::Validator
  def validate(record)
    if record.sender_id == record.receiver_id
      record.errors.add :sender, "You cannot send a message to yourself!"
    end
  end
end

class Message < ApplicationRecord
  validates_with MessageValidator
  validates :text, presence: true, length: { in: 1..1000 }

  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
  belongs_to :receiver, foreign_key: "receiver_id", class_name: "User"
end
