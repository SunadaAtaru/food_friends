Rails.application.routes.draw do

  devise_for :users
  resources :users, only: [:show, :edit, :update]
  root 'home#index'  # 仮のルートページ設定
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
