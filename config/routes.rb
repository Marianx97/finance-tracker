Rails.application.routes.draw do
  # Root route
  root 'welcome#index'

  # Devise routes
  devise_for :users

  # Users routes
  resources :users, only: [ :show ]
  post 'add_friend', to: 'users#add_friend'
  get 'my_friends', to: 'users#my_friends'
  get 'my_portfolio', to: 'users#my_portfolio'
  delete 'remove_friend', to: 'users#remove_friend'
  get 'search_friend', to: 'users#search'

  # Stocks routes
  get 'search_stock', to: 'stocks#search'

  # UserStocks routes
  resources :user_stocks, only: [ :create, :destroy ]
end
