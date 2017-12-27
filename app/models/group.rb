class Group < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :owner, presence: true
  validates :description, presence: true, length: { maximum: 60 }
end
