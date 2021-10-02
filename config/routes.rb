Rails.application.routes.draw do
  root "home#home"

  get '/home', to: 'home#home'
  resources :users do
    resources :sites
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.

  # get '/auth/github', as: 'github_login'
  get '/auth', to: 'auth#index'
  get '/auth/github/callback', to: 'auth#create'
  get '/:owner/:project(/*file)', to: 'serve_static#index', constraints: { file: %r{.+} }
  post '/github/webhooks', to: 'github/webhooks#webhook'
end
