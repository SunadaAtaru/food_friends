require 'rails_helper'

RSpec.describe 'ユーザー', type: :request do
  # テスト用のユーザーを作成
  let(:user) { User.create(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create(email: 'other@example.com', password: 'password', username: 'otheruser') }

  # GETリクエストでユーザープロフィールを表示するテスト
  describe 'GET /users/:id' do
    it 'ユーザープロフィールを表示できること' do
      sign_in user
      get user_path(user)
      expect(response).to have_http_status(200)
    end

    it 'プロフィール画像をアップロードできること' do
      visit edit_user_path(user)
      attach_file 'user[avatar]', Rails.root.join('spec/fixtures/test_image.jpg')
      click_button '更新する'
      expect(page).to have_content('プロフィールを更新しました')
      visit user_path(user)
      expect(page).to have_selector("img")
    end
  end

  # GETリクエストでユーザープロフィール編集ページを表示するテスト
  describe 'GET /users/:id/edit' do
    context '自分のプロフィールを編集する場合' do
      it '編集フォームを表示できること' do
        sign_in user
        get edit_user_path(user)
        expect(response).to have_http_status(200)
      end
    end

    context '他のユーザーのプロフィールを編集しようとした場合' do
      it 'ユーザープロフィールページにリダイレクトされること' do
        sign_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to(user_path(other_user))
      end
    end
  end

  # PATCHリクエストでユーザープロフィールを更新するテスト
  describe 'PATCH /users/:id' do
    context '有効なパラメータが送信された場合' do
      it 'プロフィールを更新できること' do
        sign_in user
        patch user_path(user), params: {
          user: {
            username: 'newname',
            introduction: 'Hello',
            address: 'Tokyo',
            contact: '090-1234-5678'
          }
        }
        expect(user.reload.username).to eq 'newname'
        expect(response).to redirect_to(user_path(user))
      end
    end

    context '無効なパラメータが送信された場合' do
      it 'プロフィールが更新されないこと' do
        sign_in user
        patch user_path(user), params: {
          user: {
            username: '' # usernameは必須
          }
        }
        expect(response).to render_template(:edit)
      end
    end
  end
end
