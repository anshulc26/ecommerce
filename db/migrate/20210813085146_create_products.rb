class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :sku, null: false
      t.float :price, null: false
      t.integer :quantity, null: false
      t.string :image

      t.timestamps

      t.index :user_id
      t.index :name
      t.index :sku
      t.index :price
      t.index :quantity
    end
  end
end
