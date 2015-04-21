class Product < ActiveRecord::Base
  has_many :orders
  belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :value, presence: true, numericality: {greater_than: 0}
  validates :width, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :height, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :length, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :weight, presence: true, numericality: {greater_than_or_equal_to: 0}
    
  scope :belong_to_merchant, ->(merchant_id) { where("merchant_id = ?", merchant_id) }
  
  def self.create_product(name, description, width, height, length, weight, value)
    product = Product.create(name: name, description: description, width: width, height: height, length: length, weight: weight, value: value)
    if product.valid?
      puts "Product Added"
    else
      # We can customize this based on the level of readability required.
      puts "Product Failed to be Added #{product.errors.messages.inspect}"
    end
  end
end
