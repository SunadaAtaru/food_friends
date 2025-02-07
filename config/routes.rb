Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: %i[show edit update]
  root 'home#index' # 仮のルートページ設定

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
