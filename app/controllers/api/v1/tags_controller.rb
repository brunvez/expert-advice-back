module Api
  module V1
    class TagsController < Api::V1::ApiController
      def index
        tags = Tag.all.distinct

        render json: tags, each_serializer: TagSerializer
      end
    end
  end
end
