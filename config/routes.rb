Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  mount Ecomm::Engine => '/store'

  get 'home/index'
  get 'catalog/index'

  resources :books, only: :show do
    resources :reviews, only: [:new, :create]
  end

  resources :orders, only: [:index, :show]
  resource :settings, only: :show do
    resource :address, only: :update
    resource :email, only: :update
  end
end
