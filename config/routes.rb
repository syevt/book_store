Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  mount Ecomm::Engine => '/store'

  get 'home/index'
  get 'catalog/index'

  resources :books, only: :show
  resources :orders, only: [:index, :show]
end
