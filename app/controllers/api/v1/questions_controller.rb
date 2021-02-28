module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, except: :index

      def index
        questions = paginate QuestionsQuery.new.all

        render json: questions, each_serializer: QuestionSerializer
      end

      def create
        question = QuestionCreation.new(title: question_params[:title],
                                        description: question_params[:description],
                                        creator: current_user,
                                        tags: question_params[:tags] || []).call

        render json: question, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: e.record,
               status: :unprocessable_entity,
               serializer: ActiveModel::Serializer::ErrorSerializer
      end

      def update
        question = Question.find(params[:id])

        QuestionEdition.new(question: question,
                            title: question_params[:title],
                            description: question_params[:description],
                            tags: question_params[:tags],
                            editor: current_user).call

        render json: question
      rescue QuestionEdition::InvalidEditor => e
        render json: serialize_errors([e]),
               status: :unauthorized
      rescue ActiveRecord::RecordInvalid => e
        render json: e.record,
               status: :unprocessable_entity,
               serializer: ActiveModel::Serializer::ErrorSerializer
      end

      def destroy
        current_user.questions.find(params[:id]).destroy!
        OrphanTagsCleaner.new.clean

        render head: :no_content
      rescue ActiveRecord::RecordNotFound
        render json: serialize_errors([StandardError.new('You cannot delete that question')]),
               status: :unauthorized
      end

      private

      def question_params
        params.require(:data).require(:attributes).permit(:title, :description, tags: [])
      end
    end
  end
end
