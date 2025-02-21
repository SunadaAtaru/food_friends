class AddPickupInfoToFoodPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :food_posts, :expiration_date, :date, null: false
    add_column :food_posts, :pickup_location, :string, null: false
    add_column :food_posts, :pickup_time_slot, :string
  end
end
