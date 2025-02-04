# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザー認証', type: :request do
  # サインインページへのGETリクエストに対するテスト
  describe 'GET /users/sign_in' do
    it '成功レスポンスが返されること' do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  # サインイン処理のPOSTリクエストに対するテスト
  describe 'POST /users/sign_in' do
    # テスト用のユーザーを事前に作成
    let!(:user) { User.create(email: 'test@example.com', password: 'password') }

    # 正しい認証情報でサインインが成功することをテスト
    it 'ユーザーがサインインできること' do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'password'
        }
      }
      expect(response).to redirect_to(root_path)
    end

    # 間違った認証情報でサインインが失敗することをテスト
    it '誤った認証情報ではサインインに失敗すること' do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'wrong_password'
        }
      }
      expect(response).not_to redirect_to(root_path)
    end
  end
end
