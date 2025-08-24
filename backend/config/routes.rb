Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :companies
      resources :users
      resources :tasks do
        member do
          patch :complete
        end
      end

      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      post "auth/logout", to: "auth#logout"
    end
  end
end
