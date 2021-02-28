module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :doorkeeper_authorize!

      def create
        question = Question.find(params[:question_id])
        answer = AnswerQuestion.new(question: question, user: current_user, answer: answer_params[:text]).post_answer

        render json: answer, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: e.record,
               status: :unprocessable_entity,
               serializer: ActiveModel::Serializer::ErrorSerializer
      end

      private

      def answer_params
        params.require(:data).require(:attributes).permit(:text)
      end
    end
  end
end
