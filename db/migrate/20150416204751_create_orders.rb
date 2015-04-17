class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.integer :quantity

      t.timestamps
    end
  end
end
