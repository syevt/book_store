Rails.application.routes.draw do
  root to: 'catalog#index'

  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  mount Ecomm::Engine => '/store'

  get 'catalog/index'

  resources :books, only: :show
end
