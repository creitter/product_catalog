class Order < ActiveRecord::Base
  belongs_to :product
  validates :name, :street_address, :city, :state, :zipcode, :quantity, presence: true
end
