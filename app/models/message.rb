class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true
  validates :readby, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :priority, presence: true, inclusion: { in: %w[normal urgent critical],
                                                    message: '%{value} is not a valid priority' }
end
