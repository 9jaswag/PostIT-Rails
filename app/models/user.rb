class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save { self.username = username.downcase }
  has_many :group_members
  has_many :groups, through: :group_members
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :username, presence: true, length: { maximum: 20 },
                        uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end
