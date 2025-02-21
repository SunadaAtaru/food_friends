require 'rails_helper'
require 'nokogiri'

RSpec.describe 'PasswordResets', type: :system do
  let(:user) { create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  it 'パスワードリセットの一連の流れが正常に動作する' do
    visit new_user_password_path

    fill_in 'メールアドレス', with: user.email
    click_button 'パスワードリセット手順を送信'

    expect(page).to have_content('パスワードの再設定について数分以内にメールでご連絡いたします')
    expect(ActionMailer::Base.deliveries.size).to eq(1)

    # メールからリセットトークンを取得
    mail = ActionMailer::Base.deliveries.last
    token = mail.body.encoded[/reset_password_token=([^"]+)/, 1]

    # 完全なリセットURLにアクセス
    visit edit_user_password_path(reset_password_token: token)

    fill_in 'user[password]', with: 'newpassword123'
    fill_in 'user[password_confirmation]', with: 'newpassword123'
    click_button 'パスワードを変更する'

    expect(page).to have_content('パスワードが正しく変更されました')
  end
end
