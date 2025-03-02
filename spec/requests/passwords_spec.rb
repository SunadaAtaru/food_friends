require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'POST /password' do
    let(:user) { create(:user) }

    it 'パスワードリセットメールを送信する' do
      expect do
        post user_password_path, params: { user: { email: user.email } }
      end.to change { ActionMailer::Base.deliveries.count }.by(1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it '存在しないメールアドレスの場合はメールを送信しない' do
      expect do
        post user_password_path, params: { user: { email: 'wrong@example.com' } }
      end.not_to(change { ActionMailer::Base.deliveries.count })
    end
  end
end
