class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :email_downcase
  before_create :create_activation_digest, :set_admin_activated

  EMAIL_VALID_REGEX = Settings.models.user.email.regexp_valid
  NAME_MAX_LENGTH = Settings.models.user.name.max_length
  EMAIL_MAX_LENGTH = Settings.models.user.email.max_length
  PASS_MIN_LENGTH = Settings.models.user.password.min_length
  PASS_MAX_LENGTH = Settings.models.user.password.max_length

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :email, presence: true, length: { maximum: EMAIL_MAX_LENGTH }, format: { with: EMAIL_VALID_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: PASS_MIN_LENGTH, maximum: PASS_MAX_LENGTH }, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def activate?
    activated.present?
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    expired = Settings.models.user.expired.hours
    reset_sent_at < expired.hours.ago
  end

  private

  def email_downcase
    email.downcase!
  end

  def set_admin_activated
    self.admin = false
    self.activated = false
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
