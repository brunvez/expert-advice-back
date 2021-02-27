ApiPagination.configure do |config|
  config.paginator = :kaminari

  config.page_param do |params|
    params[:page][:number] if params[:page].is_a?(ActionController::Parameters)
  end

  config.per_page_param do |params|
    params[:page][:size] if params[:page].is_a?(ActionController::Parameters)
  end
end
