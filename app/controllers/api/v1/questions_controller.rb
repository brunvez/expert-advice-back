module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, except: :index

      def create
        question = QuestionCreation.new(title: question_params[:title],
                                        description: question_params[:description],
                                        tags: question_params[:tags] || []).call

        render json: question, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: e.record,
               status: :unprocessable_entity,
               serializer: ActiveModel::Serializer::ErrorSerializer
      end

      private

      def question_params
        params.require(:data).require(:attributes).permit(:title, :description, tags: [])
      end
    end
  end
end
