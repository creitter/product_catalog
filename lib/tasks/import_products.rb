#!/usr/bin/env ruby
require 'csv'

def import_products(filename)
  products = Array.new
  
  filename = "products.csv" if filename.empty?
  if File.exists?(filename) 
    # Check size, if it's too big, we need to break it in pieces
  
    CSV.foreach(filename) do |row|
      name = row[0]
      description = row[1]
      value = row[2]
      height = 0
      weight = 0
      length = 0
      width = 0
      
      product = Product.create(name: name, description: description, value: value, height: height, width: width, length: length, weight: weight)
      product.save
      
      puts "row #{row.inspect}"
      puts "product #{product.inspect}"
      # Validate they don't already exist before adding them.
      products << row
    end
  end    
  puts products.count
end



# TODO: Determine the correct way to write a ruby program for importing 

puts "Please enter the CSV for the products to import:"
filename = gets
import_products(filename.chomp)
