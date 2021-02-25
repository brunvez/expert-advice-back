class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :tags

  def tags
    object.tags.map(&:text)
  end
end
