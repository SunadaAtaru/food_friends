# spec/requests/users/registrations_spec.rb
require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    sign_in user
  end

  describe 'PUT /users' do
    context 'メールアドレスの更新' do
      it '現在のパスワードと共に新しいメールアドレスを更新できる' do
        put user_registration_path, params: {
          user: {
            email: 'new@example.com',
            current_password: 'password'
          }
        }
        expect(response).to redirect_to(user_path(user))
        expect(user.reload.email).to eq 'new@example.com'
      end
    end

    context 'パスワードの更新' do
      it '現在のパスワードと共に新しいパスワードを更新できる' do
        put user_registration_path, params: {
          user: {
            password: 'newpassword',
            password_confirmation: 'newpassword',
            current_password: 'password'
          }
        }
        expect(response).to redirect_to(user_path(user))
      end
    end
  end

  describe 'DELETE /users' do
    it 'アカウントを削除できる' do
      expect {
        delete user_registration_path
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end
end