Rails.application.routes.draw do
  use_doorkeeper

   namespace :api do
    namespace :v1 do
      get '/users/me', to: 'users#me'
      resources :users
      resources :questions, only: %i(index create update destroy) do
        resources :answers, only: %i(create)
      end
      resources :tags, only: %i(index)
    end
  end
end
