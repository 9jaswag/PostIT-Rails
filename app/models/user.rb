class User < ApplicationRecord
  attr_accessor :activation_token, :reset_token
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

  # returns the hash digest of a given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

  def password_reset_expired?
    reset_time < 2.hours.ago
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") # no need for self.send as we're in the user model
    return false if digest.nil?
    # verify the token matches the digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Sends activation mail to user
  def send_activation_mail
    UserMailer.account_activation(self).deliver_now
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    # update(reset_token:, User.digest(User.new_token))
    # update(reset_time:, Time.zone.now)
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_time: Time.zone.now
    )
  end

  # Activates a user's account
  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_time, Time.zone.now)
    update_columns(activated: true, activated_time: Time.zone.now)
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
