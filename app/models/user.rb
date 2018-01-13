class User < ApplicationRecord
  attr_accessor :activation_token
  before_save { self.email = email.downcase }
  before_save { self.username = username.downcase }
  before_create :create_activation_digest
  has_many :group_members
  has_many :groups, through: :group_members
  has_many :messages
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :username, presence: true, length: { maximum: 20 },
                        uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  def self.search(search_term)
    if search_term.blank?
      all
    else
      where('username LIKE ?', "%#{search_term}%")
    end
  end

  # returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # downcase method
  # def downcase(attr)
  #   self.attr = attr.downcase
  # end

  # returns the hash digest of a given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

  private
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
