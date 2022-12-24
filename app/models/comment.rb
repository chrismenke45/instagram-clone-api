class Comment < ApplicationRecord
  validates :text, presence: true, length: { in: 1..2200 }

  belongs_to :post

  belongs_to :user
end
