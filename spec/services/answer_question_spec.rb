require 'rails_helper'

describe AnswerQuestion do
  let(:user) { create(:user) }
  let(:question) do
    QuestionCreation.new(
      title: 'How you doin',
      description: 'Description',
      creator: create(:user),
      tags: []).call
  end

  it 'creates an answer on the question for the user' do
    answer = AnswerQuestion.new(question: question, user: user, answer: 'Joey').post_answer

    expect(answer.text).to eq('Joey')
    expect(question.answers).to include(answer)
    expect(user.answers).to include(answer)
  end
end
