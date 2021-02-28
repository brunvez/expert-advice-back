require 'rails_helper'

describe QuestionsQuery do
  describe '#all' do
    let!(:questions) { create_list(:question, 4) }

    it 'returns a list of questions' do
      result = QuestionsQuery.new.all
      expect(result).to match_array(questions)
    end
  end
end