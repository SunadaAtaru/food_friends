class AddProfileFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string, null: false  # 必須項目
    add_index :users, :username, unique: true  # ユーザー名の重複を防ぐ
    
    add_column :users, :introduction, :text  # 自己紹介は任意
    
    add_column :users, :address, :string  # 住所は任意だが、投稿時に必要
    
    add_column :users, :contact, :string  # 連絡先は任意
    
    # デフォルトで公開
    add_column :users, :profile_visibility, :boolean, default: true, null: false
  end
end
