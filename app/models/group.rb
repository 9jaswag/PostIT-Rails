class Group < ApplicationRecord
  # before_save { self.owner = owner of the group }
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :owner, presence: true
  validates :description, presence: true, length: { maximum: 60 }
end
