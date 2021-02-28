# Fetches Questions from the DB together with their
# tags.
class QuestionsQuery
  def all(filter: {})
    apply_filter(Question.preload(:tags, :answers).order(created_at: :desc), filter)
  end

  private

  def apply_filter(collection, filter)
    return collection if filter[:tags].blank?

    tags = filter[:tags].map(&:strip)
    collection.joins(:tags).where(tags: { text: tags }).distinct
  end
end
