class QuestionsSerializer < ActiveModel::Serializer::CollectionSerializer
  attributes :id, :title, :description, :tags

  def tags
    object.tags.map(&:text)
  end
end
