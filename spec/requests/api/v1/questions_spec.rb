require 'rails_helper'

describe '/api/v1/questions' do

  describe 'GET' do
    subject { get '/api/v1/questions', params: params, headers: jsonapi_request_headers }

    context 'with pagination' do
      let(:params) do
        {
          per_page: 2,
          page: 1
        }
      end
      let!(:questions) do
        4.times.collect do |i|
          QuestionCreation.new(title: "Question #{i}", description: "Question #{i}", tags: Array(i)).call
        end
      end

      it 'is successful' do
        subject

        expect(response).to be_successful
      end

      it 'returns a list of paginated questions' do
        subject
        expect_questions = questions.last(2)

        expect(json).to include(
          "data" => [
            a_hash_including('id' => expect_questions.last.id.to_s),
            a_hash_including('id' => expect_questions.first.id.to_s)
          ]
        )
      end
    end
  end

  describe 'POST' do
    subject { post '/api/v1/questions', params: { data: { attributes: params } }.to_json, headers: headers }

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
            "data" => {
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
end