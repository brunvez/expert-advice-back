require 'rails_helper'

describe '/api/v1/answers' do

  describe 'POST' do
    subject { post api_v1_question_answers_path(question), params: { data: { attributes: params } }.to_json, headers: headers }

    let(:question) do
      QuestionCreation.new(
        title: 'Why?',
        description: 'Why why why',
        creator: create(:user),
        tags: []).call
    end

    context 'with a logged in user' do
      let(:headers) { jsonapi_request_headers.merge(json_api_auth_headers) }

      context 'with valid parameters' do
        let(:params) do
          {
            text: 'Because I say so'
          }
        end

        it 'returns a 201 Created status' do
          subject

          expect(response).to be_created
        end

        it 'creates an answer' do
          expect { subject }.to change(question.answers, :count).by(1)
        end

        it 'returns the question' do
          subject

          expect(json).to include(
                            'data' => a_hash_including(
                              'id' => '3',
                              'type' => 'answers',
                              'attributes' => {
                                'text' => 'Because I say so'
                              }
                            ))
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            text: ''
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
                'pointer' => '/data/attributes/text'
              },
              'detail' => "can't be blank"
            }])
        end
      end
    end
  end
end
