Rails.application.routes.draw do
  mount Ecomm::Engine => '/store'
  devise_for :users
  get 'catalog/index'
end
