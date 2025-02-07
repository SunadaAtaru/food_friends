# spec/system/user_management_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザーアカウント管理', type: :system do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    sign_in user

    # execute_script('Turbolinks.disable()')
  end

  describe 'アカウント設定' do
    it 'メールアドレスを更新できる' do
      visit edit_user_registration_path
      
      fill_in 'メールアドレス', with: 'new@example.com'
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'

      expect(page).to have_content('アカウント情報を更新しました')
      expect(user.reload.email).to eq 'new@example.com'
    end

    it 'パスワードを更新できる' do
      visit edit_user_registration_path
      
      fill_in '新しいパスワード', with: 'newpassword'
      fill_in '新しいパスワード（確認）', with: 'newpassword'
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'

      expect(page).to have_content('アカウント情報を更新しました')
    end

    
    it 'アカウントを削除できる', js: true do
      visit edit_user_registration_path
    
      # ダイアログの確認と削除ボタンのクリックを一括処理
      page.accept_confirm('本当にアカウントを削除しますか？') do
        find('a.delete-button', text: 'アカウントを削除する').click
      end
    
      # リダイレクト後のページが正しいか確認
      expect(page).to have_current_path(root_path, wait: 10)
    
      # ユーザーが削除されたか確認
      expect(User.count).to eq(0)
      expect(page).to have_content('アカウントが正常に削除されました。')

    end
    
  end
end