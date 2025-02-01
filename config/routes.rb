Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'  # 仮のルートページ設定
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
