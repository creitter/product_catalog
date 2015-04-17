class AddMerchantReferenceToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :merchant
  end
end
