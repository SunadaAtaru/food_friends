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

  resources :users, only: %i[show edit update]

  # 管理者用のユーザー管理機能
  namespace :admin do
    resources :users, only: %i[index destroy] # 一覧表示と削除
  end

  # 開発環境限定: メールプレビュー
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # 📌 ここに追加！（個別のルーティングは `resources` の後に配置するのが一般的）
  get '/404', to: 'errors#not_found'
end
