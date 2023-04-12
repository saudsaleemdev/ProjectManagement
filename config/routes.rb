Rails.application.routes.draw do
  resources :members
  resources :teams do
    resources :members, only: [:index], to: 'teams#members'
  end
  resources :projects do
    # resources :members, only: :create
    resources :members, only: [:update], to: 'projects#add_member'
    resources :members, only: :index, to: 'projects#members'
  end
end
