class ChangeValueColumnToMoney < ActiveRecord::Migration
  def change
    change_column :products, :value, :decimal, :precision => 8, :scale => 2
  end
end
