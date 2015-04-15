class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :width
      t.float :length
      t.float :height
      t.float :weight
      t.integer :value

      t.timestamps
    end
  end
end
