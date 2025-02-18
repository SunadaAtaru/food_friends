require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '管理者権限' do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }

    context '管理者の場合' do
      before do
        user # テスト実行前にユーザーを作成
        sign_in admin
      end

      it 'ユーザーを削除できる' do
        # 変化が正しく検出できる
        expect do
          delete user_path(user) # 既に存在するユーザーを削除
        end.to change(User, :count).by(-1)
      end
    end

    context '一般ユーザーの場合' do
      before do
        user
        sign_in user
      end

      it 'ユーザーを削除できない' do
        expect do
          delete user_path(user)
        end.not_to change(User, :count)
      end
    end
  end
end
