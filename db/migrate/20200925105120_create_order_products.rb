class CreateOrderProducts < ActiveRecord::Migration[5.2]
  def change
    create_join_table :orders, :products
  end
end
