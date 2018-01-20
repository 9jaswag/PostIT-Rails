class Group < ApplicationRecord
  has_many :group_members
  has_many :users, through: :group_members
  has_many :messages
  validates :name, presence: true, uniqueness: true,
                  length: { maximum: 30 }
  validates :owner, presence: true
  validates :description, presence: true,
                          length: { maximum: 60 }
end
