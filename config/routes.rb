Rails.application.routes.draw do
  devise_for :users
  get 'catalog/index'
end
