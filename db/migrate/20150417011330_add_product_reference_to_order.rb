class AddProductReferenceToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :product
  end
end
