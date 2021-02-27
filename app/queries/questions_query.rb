# Fetches Questions from the DB together with their
# tags.
class QuestionsQuery
  def all
    Question.preload(:tags).order(created_at: :desc)
  end
end
