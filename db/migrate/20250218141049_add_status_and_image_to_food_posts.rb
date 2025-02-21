class AddStatusAndImageToFoodPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :food_posts, :status, :string, default: 'available', null: false
    add_column :food_posts, :image, :string
    add_column :food_posts, :reason, :string
  end
end
