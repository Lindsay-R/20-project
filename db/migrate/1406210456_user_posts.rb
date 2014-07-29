class UserPosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string :image
      t.string :description
      t.integer :user_id
    end
  end

  def down
    drop_table :posts
  end
end
