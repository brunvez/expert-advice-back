require 'rails_helper'

describe QuestionsQuery do
  describe '#all' do
    let(:creator) { create(:user) }
    let!(:questions) do
      (1..4).collect do |i|
        QuestionCreation.new(title: "Q #{i}", description: "D #{i}", creator: creator, tags: (1..i).to_a).call
      end
    end

    it 'returns a list of questions' do
      result = QuestionsQuery.new.all
      expect(result).to match_array(questions)
    end

    it 'filters based on the inclusion of any of the sent tags' do
      result = QuestionsQuery.new.all(filter: { tags: %w(3 4) })

      expect(result).to match_array(questions.last(2))
    end
  end
end
