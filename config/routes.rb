Rails.application.routes.draw do
  resources :games, except: [:edit, :index]

  post '/games/:id', to: 'games#guess', as: 'guess'

  root 'games#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
