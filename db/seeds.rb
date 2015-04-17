# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Product.delete_all
Order.delete_all
Merchant.delete_all

puts "All Products, Orders and Merchants cleared"


merchant = Merchant.create({name: "Sellers of Everything"})
merchant_not = Merchant.create({name: "Not My Merchant"})


product = Product.create({name:"Widget Maker", description:"It's not a hole punch, it's better", value:100000.00, weight:15, height:2, length:32, width: 3, merchant: merchant})
product2 = Product.create({name:"No one every buys this", description:"It's so good, no one knows what it's for so they don't buy it", value:1.00, weight:13.986, height:2.123, length:4, width: 3.9744, merchant: merchant})
Product.create({name:"No one every buys this", description:"It's so good, no one knows what it's for so they don't buy it", value:1.00, weight:13.986, height:2.123, length:4, width: 3.9744, merchant: merchant_not})

Order.create({name: "Sally Smothers", street_address: "157 W El Camino Real", city:"Sunnyvale", state:"CA", zipcode:"94087", quantity:2, product:product})
Order.create({name: "Xanh", street_address: "110 Castro St", city:"Mountain View", state:"CA", zipcode:"94041", quantity:40, product:product})

puts "Number of Products Created #{Product.all.count}"
puts "Number of Orders Created #{Order.all.count}"
puts "Number of Merchants Created #{Merchant.all.count}"
