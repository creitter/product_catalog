class Order < ActiveRecord::Base
  belongs_to :product
  validates :name, :street_address, :city, :state, :zipcode, :quantity, presence: true
  
  def product_name
    return self.product.name
  end
end
