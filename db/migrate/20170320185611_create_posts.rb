class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :body
      t.timestamps null: false
    end

    add_index :posts, :user_id
    add_index :posts, :title
    add_index :posts, :created_at
  end
end
