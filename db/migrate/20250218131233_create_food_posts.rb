class CreateFoodPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :food_posts do |t|
      t.string :title, null: false
      t.text :description
      t.integer :quantity, null: false
      t.string :unit, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
