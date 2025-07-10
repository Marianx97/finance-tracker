Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  get 'my_friends', to: 'users#my_friends'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_friend', to: 'users#search'
  get 'search_stock', to: 'stocks#search'
  post 'add_friend', to: 'users#add_friend'
  delete 'remove_friend', to: 'users#remove_friend'
  resources :user_stocks, only: [ :create, :destroy ]
end
