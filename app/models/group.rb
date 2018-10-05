class Group < ApplicationRecord
  has_many :group_members
  has_many :users, through: :group_members
  has_many :messages
  validates :name, presence: true, uniqueness: true,
                   length: { maximum: 30 }
  validates :owner, presence: true
  validates :description, presence: true,
                          length: { maximum: 60 }

  # Get a users unread message count for a group
  def self.unread_count(id, username)
    messages = Group.find(id).messages
    if messages
      count = 0
      messages.each do |message|
        count += 1 unless message.readby.include?(username)
      end
      count
    end
  end
end
