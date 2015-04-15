class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :value, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :width, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :height, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :length, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :weight, presence: true, numericality: {greater_than_or_equal_to: 0}
end
