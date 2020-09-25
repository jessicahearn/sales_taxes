class CreateTaxCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_categories do |t|
    	t.string :name
      t.boolean :sales_tax_exempt, null: false, default: false

      t.timestamps
    end
  end
end
