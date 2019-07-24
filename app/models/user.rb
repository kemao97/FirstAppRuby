class User < ApplicationRecord
  attr_accessor :remember_token

  EMAIL_VALID_REGEX = Settings.models.user.email.regexp_valid
  NAME_MAX_LENGTH = Settings.models.user.name.max_length
  EMAIL_MAX_LENGTH = Settings.models.user.email.max_length
  PASS_MIN_LENGTH = Settings.models.user.password.min_length
  PASS_MAX_LENGTH = Settings.models.user.password.max_length

  before_save { email.downcase }

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :email, presence: true, length: { maximum: EMAIL_MAX_LENGTH }, format: { with: EMAIL_VALID_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: PASS_MIN_LENGTH, maximum: PASS_MAX_LENGTH }

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
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

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end
end
