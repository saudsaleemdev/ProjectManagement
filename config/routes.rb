Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :members
  resources :teams do
    resources :members, only: [:index], module: 'teams'
  end

  resources :projects do
    resources :members, only: [:index], module: 'projects'
  end

  root "projects#index"
end
