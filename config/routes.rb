Rails.application.routes.draw do
  namespace :admin do
    get 'users/index'
    get 'users/destroy'
  end

  root 'home#index' # 仮のルートページ設定

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  resources :users
  # 食品投稿機能のルーティングを追加
  resources :food_posts
  
  # 食品リクエスト機能のルーティングを追加
  resources :food_posts do
    resources :food_requests, only: [:new, :create]
  end
  
  resources :food_requests, only: [:index, :show] do
    member do
      patch :accept
      patch :reject
      patch :cancel
    end
  end

  # 管理者用のユーザー管理機能
  namespace :admin do
    resources :users, only: %i[index destroy] # 一覧表示と削除
  end

  # 開発環境限定: メールプレビュー
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # 📌 ここに追加！（個別のルーティングは `resources` の後に配置するのが一般的）
  get '/404', to: 'errors#not_found'
end