# spec/system/confirmations_spec.rb
require 'rails_helper'

RSpec.describe 'UserConfirmations', type: :system do
  it 'メールアドレスの確認が正常に完了する' do
    visit new_user_registration_path

    fill_in 'ユーザー名', with: 'testuser123'
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認）', with: 'password123'

    click_button 'アカウント登録'

    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end
end