Rails.application.routes.draw do
  devise_for :users

  get '/check_email_unique' => 'users#check_email_unique', as: :check_email_unique

  resources :products

  get '/marketplace', to: 'marketplace#index', as: :marketplace

  root to: 'dashboard#index'
end
