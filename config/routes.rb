Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :members
  resources :teams
  resources :projects

  get '/teams/:id/members', to: 'teams#members', as: 'team_members'
  get '/projects/:project_id/members', to: 'projects#members', as: 'project_members'
  patch '/projects/:project_id/members/:member_id', to: 'projects#add_member', as: 'add_member_to_project'
end
