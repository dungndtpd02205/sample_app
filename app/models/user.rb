class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true,
    length: {maximum: Settings.input.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.input.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password,
    length: {minimum: Settings.input.password.min_length}

  before_save{email.downcase!}

  has_secure_password
end
