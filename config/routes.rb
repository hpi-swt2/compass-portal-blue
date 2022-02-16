Rails.application.routes.draw do
  get 'error/show'
  resources :events do
    collection { post :import }
  end
  resources :people

  get '/favourites', to: 'favourites#list', as: 'get_favourites'
  put '/rooms/:id/favourite', to: 'favourites#set_favourite_room', as: 'put_favourite_rooms'
  put '/buildings/:id/favourite', to: 'favourites#set_favourite_building', as: 'put_favourite_buildings'
  put '/locations/:id/favourite', to: 'favourites#set_favourite_location', as: 'put_favourite_locations'
  put '/people/:id/favourite', to: 'favourites#set_favourite_person', as: 'put_favourite_people'
  resources :rooms do
    get 'calendar'
  end

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

  # '/building/map'
  get '/building_map/route', to: 'building_map#route'
  get '/building_map/view', to: 'building_map#view'

  # '/search_results'
  get '/search_results', to: 'search_results#index'

  put '/users/geo_location', to: 'users/geo_locations#update'
  delete '/users/geo_location', to: 'users/geo_locations#delete'

  # '/'
  # Sets `root_url`, devise gem requires this to be set
  root to: "welcome#index"

  get '/map/*path' => "welcome#index", as: 'map'

  get 'users/roles'
  put '/users/:id/roles', to: 'users#update_roles'
end
