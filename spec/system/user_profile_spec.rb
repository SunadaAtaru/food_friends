# spec/system/user_profile_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザープロフィール管理', type: :system do
  let(:user) { User.create(email: 'test@example.com', password: 'password', username: 'testuser') }

  # テスト実行時にブラウザドライバを指定
  before do
    driven_by(:rack_test)
  end

  describe 'プロフィールの表示と編集' do
    before do
      sign_in user
    end

    # ユーザーが自分のプロフィールを表示できることをテスト
    it 'ユーザーが自分のプロフィールを表示できること' do
      visit user_path(user)
      expect(page).to have_content(user.username)
      expect(page).to have_link('プロフィールを編集')
    end

    # ユーザーがプロフィールを編集できることをテスト
    it 'ユーザーが自分のプロフィールを編集できること' do
      visit edit_user_path(user)
      
      fill_in 'ユーザー名', with: 'updated_username'
      fill_in '自己紹介', with: 'Hello, this is my profile'
      fill_in '住所', with: 'Tokyo'
      fill_in '連絡先', with: '090-1234-5678'
      check 'プロフィールを公開する'
      
      click_button '更新する'
      
      expect(page).to have_content('updated_username')
      expect(page).to have_content('Hello, this is my profile')
    end
  end

  describe 'プロフィールの公開・非公開' do
    let(:other_user) { User.create(email: 'other@example.com', password: 'password', username: 'otheruser') }

    before do
      sign_in other_user
    end

    # 公開されているプロフィール情報を他のユーザーが閲覧できることをテスト
    it '他のユーザーが公開プロフィールを表示できること' do
      user.update(profile_visibility: true)
      visit user_path(user)
      expect(page).to have_content(user.username)
    end

    # 他のユーザーが編集ボタンを表示できないことをテスト
    it '他のユーザーが編集ボタンを表示できないこと' do
      visit user_path(user)
      expect(page).not_to have_link('プロフィールを編集')
    end
  end
end
