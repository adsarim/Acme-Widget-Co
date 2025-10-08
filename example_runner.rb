#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/product'
require_relative 'lib/catalog'
require_relative 'lib/basket'
require_relative 'lib/offers/buy_one_get_second_half_price'
require_relative 'lib/delivery_rules/tiered_delivery_rule'

catalog = Catalog.new([
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
])

delivery_rule = DeliveryRules::TieredDeliveryRule.new(
  tiers: [
    { threshold: 0, cost: 4.95 },   # Orders under $50
    { threshold: 50, cost: 2.95 },  # Orders $50-$89.99
    { threshold: 90, cost: 0 }      # Orders $90+
  ]
)

offers = [
  Offers::BuyOneGetSecondHalfPrice.new(product_code: 'R01')
]

def demonstrate_basket(basket, products, description)
  puts "\n" + "=" * 60
  puts description
  puts "=" * 60
  
  products.each do |code|
    basket.add(code)
    product = basket.items.last
    puts "Added: #{product.name} (#{product.code}) - $#{product.price}"
  end
  
  puts "\n#{'-' * 60}"
  puts "TOTAL: $#{'%.2f' % basket.total}"
  puts "=" * 60
end

puts "\n"
puts "╔════════════════════════════════════════════════════════════╗"
puts "║           ACME WIDGET CO - BASKET CALCULATOR              ║"
puts "╔════════════════════════════════════════════════════════════╗"
puts "\n"

basket1 = Basket.new(catalog: catalog, delivery_rule: delivery_rule, offers: offers)
demonstrate_basket(basket1, ['B01', 'G01'], 'Test Case 1: B01, G01 (Expected: $37.85)')

basket2 = Basket.new(catalog: catalog, delivery_rule: delivery_rule, offers: offers)
demonstrate_basket(basket2, ['R01', 'R01'], 'Test Case 2: R01, R01 (Expected: $54.37)')

basket3 = Basket.new(catalog: catalog, delivery_rule: delivery_rule, offers: offers)
demonstrate_basket(basket3, ['R01', 'G01'], 'Test Case 3: R01, G01 (Expected: $60.85)')

basket4 = Basket.new(catalog: catalog, delivery_rule: delivery_rule, offers: offers)
demonstrate_basket(basket4, ['B01', 'B01', 'R01', 'R01', 'R01'], 
                   'Test Case 4: B01, B01, R01, R01, R01 (Expected: $98.27)')

puts "\n"

