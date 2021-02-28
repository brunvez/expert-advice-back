require 'rails_helper'

describe '/api/v1/questions' do

  describe 'GET' do
    subject { get api_v1_questions_path, params: params, headers: jsonapi_request_headers }

    let(:creator) { create(:user) }
    let!(:questions) do
      (1..4).collect do |i|
        QuestionCreation.new(title: "Q #{i}", description: "D #{i}", creator: creator, tags: (1..i).to_a).call
      end
    end

    context 'with pagination' do
      let(:params) do
        {
          page: {
            number: 1,
            size: 2
          }
        }
      end

      it 'is successful' do
        subject

        expect(response).to be_successful
      end

      it 'returns a list of paginated questions' do
        subject
        expect_questions = questions.last(2)

        expect(json).to include(
                          'data' => [
                            a_hash_including('id' => expect_questions.last.id.to_s),
                            a_hash_including('id' => expect_questions.first.id.to_s)
                          ]
                        )
      end
    end

    context 'with a filter applied' do
      let(:params) do
        {
          filter: {
            tags: %w(3 4).join(',')
          }
        }
      end

      it 'is successful' do
        subject

        expect(response).to be_successful
      end

      it 'returns the tags that match the filter' do
        subject
        expect_questions = questions.last(2)

        expect(json).to include(
                          'data' => [
                            a_hash_including('id' => expect_questions.last.id.to_s),
                            a_hash_including('id' => expect_questions.first.id.to_s)
                          ]
                        )
      end
    end
  end

  describe 'POST' do
    subject { post api_v1_questions_path, params: { data: { attributes: params } }.to_json, headers: headers }

    context 'with a logged in user' do
      let(:headers) { jsonapi_request_headers.merge(json_api_auth_headers) }

      context 'with valid parameters' do
        let(:params) do
          {
            title: 'Why?',
            description: 'Because',
            tags: %w(tag1 tag2)
          }
        end

        it 'returns a 201 Created status' do
          subject

          expect(response).to be_created
        end

        it 'creates a question' do
          expect { subject }.to change(Question, :count).by(1)
        end

        it 'returns the question' do
          subject

          expect(json).to include(
                            'data' => {
                              'id' => match(/\d+/),
                              'type' => 'questions',
                              'attributes' => {
                                'title' => 'Why?',
                                'description' => 'Because',
                                'tags' => %w(tag1 tag2)
                              }
                            })
        end
      end
    end
  end

  describe 'PUT :id' do
    subject { put api_v1_question_path(question), params: { data: { attributes: params } }.to_json, headers: headers }

    let(:headers) { jsonapi_request_headers.merge(json_api_auth_headers(user: editor)) }
    let(:question) { QuestionCreation.new(title: 'Title', description: 'Description', creator: creator, tags: %w(a b c)).call }

    context 'when the editor is the creator of the question' do
      let(:creator) { create(:user) }
      let(:editor) { creator }

      context 'when the attributes are valid' do
        let(:params) do
          {
            title: 'Title 2',
            description: 'Description 2',
            tags: %w(a b c)
          }
        end

        it 'returns a successful response' do
          subject

          expect(response).to be_successful
          expect(json).to eq('data' => {
            'id' => question.id.to_s,
            'type' => 'questions',
            'attributes' => {
              'title' => 'Title 2',
              'description' => 'Description 2',
              'tags' => %w(a b c)
            }
          })
        end

        it 'updates the question' do
          expect { subject }.to change { question.reload.title }.from('Title').to('Title 2')
        end
      end

      context 'when the attributes are invalid' do
        let(:params) do
          {
            title: '',
            description: '',
            tags: %w(a b c)
          }
        end

        it 'return an unprocessable entity response' do
          subject

          expect(response.status).to eq(422)
        end

        it 'returns the errors' do
          subject

          expect(json).to eq('errors' => [
            {
              'source' => {
                'pointer' => '/data/attributes/title'
              },
              'detail' => "can't be blank"
            },
            {
              'source' => {
                'pointer' => '/data/attributes/description'
              },
              'detail' => "can't be blank"
            }])
        end
      end
    end

    context 'when the editor is not the creator of the question' do
      let(:creator) { create(:user) }
      let(:editor) { create(:user) }

      let(:params) do
        {
          title: '',
          description: '',
          tags: %w(a b c)
        }
      end


      it 'returns an unauthorized response' do
        subject

        expect(response.status).to eq(401)
      end

      it 'returns an error message' do
        subject

        expect(json).to eq('errors' => [{ 'title' => 'Only the creator of a question can edit it' }])
      end
    end
  end

  describe 'DELETE :id' do
    subject { delete api_v1_question_path(question), headers: headers }

    let(:headers) { jsonapi_request_headers.merge(json_api_auth_headers(user: user)) }
    # tags need to be created in order to change
    let!(:question) { QuestionCreation.new(title: 'Title', description: 'Description', creator: creator, tags: %w(a b c)).call }
    let(:creator) { create(:user) }

    context 'when the question belongs to the user' do
      let(:user) { creator }

      it 'returns a successful response' do
        subject

        expect(response).to be_successful
      end

      it 'destroys the question' do
        subject

        expect { question.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'cleans orphaned tags' do
        expect { subject }.to change(Tag, :count).by(-3)
      end
    end

    context 'when the question does not belong to the user' do
      let(:user) { create(:user) }

      it 'returns unauthorized' do
        subject

        expect(response.status).to eq(401)
      end

      it 'returns an error message' do
        subject

        expect(json).to eq('errors' => [{ 'title' => 'You cannot delete that question' }])
      end

      it 'does not destroy the question' do
        subject

        expect(Question.where(id: question.id)).to exist
      end
    end
  end
end
