require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user, admin: false) }

  describe 'GET /admin/users' do
    context '管理者がアクセスする場合' do
      before do
        sign_in admin # ← 管理者としてログイン
        get admin_users_path
      end

      it '正常にレスポンスを返す (200 OK)' do
        expect(response).to have_http_status(:ok)
      end
    end

    context '一般ユーザーがアクセスする場合' do
      before do
        sign_in user
        get admin_users_path
      end

      it 'アクセスが拒否される (302 リダイレクト)' do
        expect(response).to have_http_status(:redirect)
      end

      it 'トップページにリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end
    end

    context '未ログインユーザーがアクセスする場合' do
      before { get admin_users_path }

      it 'ログインページにリダイレクトされる' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /admin/users/:id' do
    context '管理者が一般ユーザーを削除する場合' do
      before { sign_in admin }

      it 'ユーザーが削除される' do
        expect do
          delete admin_user_path(user)
        end.to change(User, :count).by(-1)
      end

      it 'ユーザー一覧ページにリダイレクトされる' do
        delete admin_user_path(user)
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context '一般ユーザーが削除しようとした場合' do
      before do
        sign_in user
        delete admin_user_path(user)
      end

      it '削除が拒否される (302 リダイレクト)' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context '未ログインユーザーが削除しようとした場合' do
      before { delete admin_user_path(user) }

      it 'ログインページにリダイレクトされる' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
