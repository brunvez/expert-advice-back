require 'rails_helper'

describe QuestionsQuery do
  describe '#all' do
    let!(:questions) do
      4.times.collect do |i|
        QuestionCreation.new(title: "Question #{i}", description: "Question #{i}", tags: Array(i)).call
      end
    end

    it 'returns a list of questions' do
      result = QuestionsQuery.new.all
      expect(result).to match_array(questions)
    end
  end
end