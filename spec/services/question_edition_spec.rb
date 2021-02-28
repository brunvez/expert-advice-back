require 'rails_helper'

RSpec.describe QuestionEdition do
  subject { QuestionEdition.new(question: question, title: title, description: description, tags: tags, editor: editor).call }

  let(:question) { QuestionCreation.new(title: 'Title', description: 'Description', creator: creator, tags: %w(a b c)).call }

  context 'when the editor is the creator of the question' do
    let(:creator) { create(:user) }
    let(:editor) { creator }

    context 'when the attributes are valid' do
      let(:title) { 'Title 2' }
      let(:description) { 'Description 2' }
      let(:tags) { %w(a b c) }

      it 'updates the question' do
        updated_question = subject

        expect(updated_question.title).to eq(title)
        expect(updated_question.description).to eq(description)
        expect(updated_question.tags.map(&:text)).to match_array(tags)
      end

      context 'when changing the tags' do
        let(:tags) { %w(1 2 c) }

        it 'adds new tags and removes other tags' do
          expect { subject }.to change { question.tags.reload.map(&:text) }.from(%w(a b c)).to(match_array(tags))
        end

        it 'destroys orphan tags' do
          tag_1 = question.tags.find_by(text: 'a')
          tag_2 = question.tags.find_by(text: 'b')

          subject

          expect { tag_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
          expect { tag_2.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when the attributes are invalid' do
      let(:title) { '' }
      let(:description) { '' }
      let(:tags) { %w(a b c) }

      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'when the editor is not the creator of the question' do
    let(:creator) { create(:user) }
    let(:editor) { create(:user) }

    let(:title) { '' }
    let(:description) { '' }
    let(:tags) { %w(a b c) }

    it 'raises an error' do
      expect { subject }.to raise_error(QuestionEdition::InvalidEditor).with_message('Only the creator of a question can edit it')
    end
  end
end
