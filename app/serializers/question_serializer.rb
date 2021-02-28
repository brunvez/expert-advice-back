class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :tags
  has_many :answers

  def tags
    object.tags.map(&:text)
  end
end
