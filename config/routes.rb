Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post"/users/current",to:"users#current"
  post"/login",to:"users#login"
  get"/logout",to:"users#logout"
  post"/fill",to:"games#fill"
  post"/join",to:"games#join"
  post"/refresh",to:"games#refresh"
  post"/winner",to:"games#winner"

  resources :games, only: [:create]
  resources :users, only: [:create]
end
