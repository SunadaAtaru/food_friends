class CreateFoodRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :food_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food_post, null: false, foreign_key: true
      t.text :message
      t.string :status, null: false, default: "pending"  # pending, accepted, rejected, canceled
      t.datetime :pickup_time
      t.text :rejection_reason
      
      t.timestamps
    end
    
    # 同じユーザーが同じ食品投稿に複数回リクエストするのを防ぐ
    add_index :food_requests, [:user_id, :food_post_id], unique: true
  end
end