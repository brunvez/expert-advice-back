require 'rails_helper'

describe '/api/v1/tags' do

  describe 'GET' do
    subject { get api_v1_tags_path, headers: jsonapi_request_headers }

    let(:creator) { create(:user) }
    let!(:questions) do
      (1..4).collect do |i|
        QuestionCreation.new(title: "Q #{i}", description: "D #{i}", creator: creator, tags: (1..i).to_a).call
      end
    end

    it 'is successful' do
      subject

      expect(response).to be_successful
    end

    it 'returns a list of all distinct tags' do
      subject

      tag_attributes = (1..4).map do |tag_number|
        {
          'id' => match(/\d+/),
          'type' => 'tags',
          'attributes' => {
            'text' => tag_number.to_s,
          }
        }
      end

      expect(json).to include('data' => match_array(tag_attributes))
    end
  end
end
