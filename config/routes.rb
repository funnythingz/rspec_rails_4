ContactsExample40::Application.routes.draw do
  get 'signin', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions

  resources :contacts

=begin
  # TODO: with phones
  resources :contacts do
    resources :phones

    member do
      patch 'hide_contact'
    end
  end
=end

  root to: 'contacts#index'
end
