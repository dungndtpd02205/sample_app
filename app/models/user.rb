class User < ApplicationRecord
  before_save{email.downcase!}
  validates :name, presence: true,
    length: {maximum: Settings.input.name.max_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
    length: {maximum: Settings.input.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.input.password.min_length}
end
