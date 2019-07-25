class User < ApplicationRecord
  EMAIL_VALID_REGEX = Settings.models.user.email.regexp_valid
  NAME_MAX_LENGTH = Settings.models.user.name.max_length
  EMAIL_MAX_LENGTH = Settings.models.user.email.max_length
  PASS_MIN_LENGTH = Settings.models.user.password.min_length
  PASS_MAX_LENGTH = Settings.models.user.password.max_length

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :email, presence: true, length: { maximum: EMAIL_MAX_LENGTH }, format: { with: EMAIL_VALID_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: PASS_MIN_LENGTH, maximum: PASS_MAX_LENGTH }

  has_secure_password
end
