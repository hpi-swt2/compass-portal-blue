Rails.application.routes.draw do
  resources :people
  resources :rooms
  resources :openingtimes
  resources :buildings
  resources :locations
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # '/users/...'
  # https://github.com/plataformatec/devise#configuring-routes
  devise_for :users, path: 'users',
    controllers: {
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
    }

  # '/login'
  get '/login', to: 'welcome#login'

  get '/building_map', to: 'building_map#index'
  get '/building_map/route', to: 'building_map#route'
  get '/building_map/markers', to: 'building_map#markers'
  get '/building_map/buildings', to: 'building_map#buildings'
  get '/building_map/view', to: 'building_map#view'

  # '/search_results'
  get '/search_results', to: 'search_results#index'

  # '/'
  # Sets `root_url`, devise gem requires this to be set
  root to: "welcome#index"
end
