require 'rails_helper'

RSpec.describe QuestionCreation do
  subject { QuestionCreation.new(title: title, description: description, tags: tags).call }

  context 'with correct params' do
    let(:title) { 'How to code?' }
    let(:description) { 'Just type type type' }
    let(:tags) { %w(Code How-To) }

    it 'creates a question' do
      question = subject

      expect(question).to be_persisted
      expect(question.title).to eq(title)
      expect(question.description).to eq(description)
    end

    it 'creates the tags for the question' do
      question = subject

      expect(question.tags.map(&:text)).to match_array(tags)
    end

    context 'when the tags already exist' do
      before do
        Tag.create!(text: tags.first)
      end

      it 'does not re-create them' do
        expect { subject }.to change(Tag, :count).by(1)
      end
    end

    context 'with duplicated tags' do
      let(:tags) { %w(Code How-To Code) }

      it 'makes them unique' do
        question = subject

        expect(question.tags.map(&:text)).to match_array(tags.uniq)
      end
    end
  end

  context 'with invalid parameters' do
    let(:title) { '' }
    let(:description) { '' }
    let(:tags) { [] }

    it 'raises an invalid record error' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
