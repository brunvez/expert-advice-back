class Question < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :creator, class_name: 'User'
  has_many :answers, dependent: :destroy

  validates :title, :description, :creator, presence: true
end
