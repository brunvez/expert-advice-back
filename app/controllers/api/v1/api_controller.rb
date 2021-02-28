module Api::V1
  class ApiController < ApplicationController
    def index
      render text: "API"
    end

    private

    def current_account_user
      @current_account_user ||=
        AccountUser.new(user: current_user, account: current_account)
    end

    def current_account
      @current_account ||=
        current_user.accounts.find_by_id(request.headers['X-accountId']) ||
        current_user.accounts.first
    end

    def current_user
      @current_user ||=
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def pagination
      per_page = (params[:per_page] || PER_PAGE).to_i
      page = (params[:page] || 1).to_i
      {
        limit: per_page,
        offset: (page - 1) * per_page
      }
    end

    def serialize_errors(errors)
      {
        errors: errors.map { |error| { title: error.message } }
      }
    end
  end
end
