Rails.application.routes.draw do
  root 'home#index' # 仮のルートページ設定
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  resources :users, only: %i[show edit update]

  # 管理者用のユーザー管理機能
  namespace :admin do
    resources :users, only: [:index, :destroy] # 一覧表示と削除
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
