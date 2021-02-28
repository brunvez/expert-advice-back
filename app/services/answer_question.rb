# Add an answer to a question associated to a user
class AnswerQuestion
  def initialize(question:, user:, answer:)
    @question = question
    @user = user
    @answer = answer
  end

  def post_answer
    question.answers.create!(text: answer, user: user)
  end

  private

  attr_reader :question, :user, :answer
end
