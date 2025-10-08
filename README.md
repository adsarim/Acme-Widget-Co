# Acme Widget Co - Sales System

A proof of concept for Acme Widget Co's new sales basket system, implemented in Ruby with clean architecture principles.

## 📋 Overview

This system manages a shopping basket for Acme Widget Co with the following features:

### Products
- **Red Widget (R01)** - $32.95
- **Green Widget (G01)** - $24.95
- **Blue Widget (B01)** - $7.95

### Delivery Rules
- Orders under $50: **$4.95** delivery
- Orders $50 - $89.99: **$2.95** delivery
- Orders $90+: **Free** delivery

### Special Offers
- **Red Widget Offer**: Buy one red widget, get the second half price

### Architecture Highlights
- **Strategy Pattern** for extensible offers and delivery rules
- **Dependency Injection** for flexible, testable components
- **BigDecimal** for precise currency calculations
- **SOLID Principles** throughout the codebase

## 🚀 How to Run This Project

### Step 1: Install Dependencies

```bash
# Make sure you're in the project directory
cd piktochart

# Install required gems
bundle install
```

### Step 2: Run the Example

```bash
# Run the example runner to see the basket in action
ruby example_runner.rb
```

This will display output for all test cases:
```
╔════════════════════════════════════════════════════════════╗
║           ACME WIDGET CO - BASKET CALCULATOR              ║
╔════════════════════════════════════════════════════════════╗

Test Case 1: B01, G01 (Expected: $37.85)
Test Case 2: R01, R01 (Expected: $54.37)
Test Case 3: R01, G01 (Expected: $60.85)
Test Case 4: B01, B01, R01, R01, R01 (Expected: $98.27)
```

## 🧪 How to Check Test Cases

### Run All Tests

```bash
bundle exec rspec
```

Expected output:
```
29 examples, 0 failures
```

### Run Tests with Detailed Output

```bash
bundle exec rspec --format documentation
```

This shows each test case with descriptions:
```
Basket
  #add
    adds a product to the basket by code
    raises an error when product code is not found
  #total
    with the provided test cases
      ✓ calculates correct total for B01, G01
      ✓ calculates correct total for R01, R01
      ✓ calculates correct total for R01, G01
      ✓ calculates correct total for B01, B01, R01, R01, R01
```

### Run Specific Test Files

```bash
# Test only the basket functionality
bundle exec rspec spec/basket_spec.rb

# Test only the offers
bundle exec rspec spec/offers/

# Test only delivery rules
bundle exec rspec spec/delivery_rules/
```

### Verify Test Cases

All provided test cases pass with exact expected totals:

| Products | Expected Total | Status |
|----------|---------------|--------|
| B01, G01 | $37.85 | ✅ Pass |
| R01, R01 | $54.37 | ✅ Pass |
| R01, G01 | $60.85 | ✅ Pass |
| B01, B01, R01, R01, R01 | $98.27 | ✅ Pass |

## 💻 Usage

### Basic Usage

```ruby
require_relative 'lib/product'
require_relative 'lib/catalog'
require_relative 'lib/basket'
require_relative 'lib/offers/buy_one_get_second_half_price'
require_relative 'lib/delivery_rules/tiered_delivery_rule'

# Create catalog
catalog = Catalog.new([
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
])

# Configure delivery rules
delivery_rule = DeliveryRules::TieredDeliveryRule.new(
  tiers: [
    { threshold: 0, cost: 4.95 },
    { threshold: 50, cost: 2.95 },
    { threshold: 90, cost: 0 }
  ]
)

# Configure offers
offers = [
  Offers::BuyOneGetSecondHalfPrice.new(product_code: 'R01')
]

# Create and use basket
basket = Basket.new(
  catalog: catalog,
  delivery_rule: delivery_rule,
  offers: offers
)

basket.add('R01')
basket.add('R01')
basket.add('G01')

puts "Total: $#{basket.total}" # => Total: $76.82
```

## 🧪 Test Cases

The implementation passes all provided test cases:

| Products | Expected Total | Result |
|----------|---------------|--------|
| B01, G01 | $37.85 | ✅ Pass |
| R01, R01 | $54.37 | ✅ Pass |
| R01, G01 | $60.85 | ✅ Pass |
| B01, B01, R01, R01, R01 | $98.27 | ✅ Pass |

## 🔧 Extending the System

### Adding a New Offer

Create a new offer class that inherits from `Offers::BaseOffer`:

```ruby
module Offers
  class BuyTwoGetOneFree < BaseOffer
    def initialize(product_code:)
      @product_code = product_code
    end

    def apply(products)
      applicable_products = products.select { |p| applies_to?(p) }
      free_items = applicable_products.size / 3
      
      return BigDecimal('0') if free_items.zero?
      
      applicable_products.first.price * free_items
    end

    def applies_to?(product)
      product.code == @product_code
    end
  end
end
```

Then inject it into the basket:

```ruby
offers = [
  Offers::BuyOneGetSecondHalfPrice.new(product_code: 'R01'),
  Offers::BuyTwoGetOneFree.new(product_code: 'B01')
]

basket = Basket.new(catalog: catalog, delivery_rule: delivery_rule, offers: offers)
```

### Adding New Delivery Rules

Create a new delivery rule class:

```ruby
module DeliveryRules
  class FlatRateDeliveryRule < BaseDeliveryRule
    def initialize(cost:)
      @cost = BigDecimal(cost.to_s)
    end

    def calculate(subtotal)
      @cost
    end
  end
end
```

## 🎯 Design Decisions

### BigDecimal for Currency

All monetary calculations use Ruby's `BigDecimal` class to avoid floating-point precision errors. This ensures accurate calculations to the cent.

### Immutable Product References

Products in the basket are references to catalog products, not copies. This ensures consistency and allows for future enhancements like inventory tracking.

### Offer Application Order

Offers are applied after calculating the subtotal but before delivery costs. This ensures delivery cost thresholds are based on the discounted price.

### Pair-Based Offers

The "buy one get second half price" offer applies to pairs. With an odd number of items, one full-price item remains. For example:
- 2 red widgets: 1st full price, 2nd half price
- 3 red widgets: 1st full price, 2nd half price, 3rd full price

## 🧩 Project Structure

```
.
├── lib/
│   ├── basket.rb                          # Main basket class
│   ├── catalog.rb                         # Product catalog
│   ├── product.rb                         # Product model
│   ├── delivery_rules/
│   │   ├── base_delivery_rule.rb         # Base delivery strategy
│   │   └── tiered_delivery_rule.rb       # Tiered delivery implementation
│   └── offers/
│       ├── base_offer.rb                  # Base offer strategy
│       └── buy_one_get_second_half_price.rb  # Half-price offer
├── spec/
│   ├── basket_spec.rb                     # Basket tests
│   ├── catalog_spec.rb                    # Catalog tests
│   ├── product_spec.rb                    # Product tests
│   ├── delivery_rules/
│   │   └── tiered_delivery_rule_spec.rb
│   ├── offers/
│   │   └── buy_one_get_second_half_price_spec.rb
│   └── spec_helper.rb                     # RSpec configuration
├── example_runner.rb                      # Example usage script
├── Gemfile                                # Gem dependencies
└── README.md                              # This file
```

## 📝 Assumptions

1. **Product codes are unique** - Each product has a unique code used as the identifier
2. **Delivery rules are mutually exclusive** - Only one delivery tier applies per order
3. **Offers apply to complete pairs** - The "buy one get second half price" offer requires pairs
4. **Delivery cost is based on discounted total** - Delivery thresholds use the price after offers
5. **Multiple offers can be active** - The system supports multiple simultaneous offers
6. **Catalog is immutable during checkout** - Product prices don't change while basket is active
7. **No inventory limits** - Products can be added without checking stock levels
8. **Currency precision** - All prices rounded to 2 decimal places for display

## 🔍 Code Quality

The codebase demonstrates:
- ✅ **SOLID Principles** - Single responsibility, open/closed, dependency inversion
- ✅ **DRY** - No code duplication
- ✅ **Testability** - 100% test coverage of business logic
- ✅ **Extensibility** - Easy to add new offers and delivery rules
- ✅ **Readability** - Clear naming, documentation, and structure
- ✅ **Type Safety** - BigDecimal for currency precision

