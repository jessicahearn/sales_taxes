class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
    	t.string :name
      t.integer :base_price_cents
      t.integer :tax_category_id
      t.boolean :imported, null: false, default: false

      t.timestamps
    end
  end
end
