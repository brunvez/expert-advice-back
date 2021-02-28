class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :text, :question, :user, presence: true
end
