Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      post 'login', to: 'auth#login'
      resources :companies
      resources :users
      resources :tasks
    end
  end
end
