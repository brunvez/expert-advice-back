# Creates questions with associated tasks
class QuestionCreation
  def initialize(title:, description:, tags:)
    @quesiton_params = { title: title, description: description }
    @tags = tags
  end

  def call
    ActiveRecord::Base.transaction do
      question = Question.create!(@quesiton_params)
      question.tags << tags.uniq.map { |text| Tag.find_or_create_by(text: text) }

      question
    end
  end

  private

  attr_reader :quesiton_params, :tags
end
