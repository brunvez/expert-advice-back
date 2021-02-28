class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true, presence: true
  validates_email_format_of :email, message: 'is not looking good'

  has_many :user_account_accesses, dependent: :destroy
  has_many :accounts, through: :user_account_accesses, dependent: :destroy
  has_many :questions, foreign_key: :creator_id, dependent: :destroy
  has_many :answers, dependent: :destroy
end
