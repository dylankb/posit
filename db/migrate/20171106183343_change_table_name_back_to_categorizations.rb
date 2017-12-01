class ChangeTableNameBackToCategorizations < ActiveRecord::Migration
  def change
    drop_table :categories_posts

    create_table :categorizations do |t|
      t.integer :post_id
      t.integer :category_id

      t.timestamps
    end
  end
end
