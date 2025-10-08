# Git Commit Guide

When you're ready to push this to GitHub, here's a suggested commit structure that demonstrates good version control practices:

## Initial Setup

```bash
git init
git add .gitignore Gemfile .rspec
git commit -m "chore: initialize project with Ruby and RSpec configuration

- Add Gemfile with RSpec dependency
- Configure .rspec for documentation format
- Add .gitignore for Ruby projects"
```

## Core Domain Models

```bash
git add lib/product.rb lib/catalog.rb
git commit -m "feat: implement Product and Catalog domain models

- Add Product class with code, name, and price attributes
- Use BigDecimal for precise currency calculations
- Implement Catalog class for product management
- Add methods for finding products by code"
```

## Strategy Pattern for Delivery Rules

```bash
git add lib/delivery_rules/
git commit -m "feat: implement delivery cost calculation with Strategy pattern

- Add BaseDeliveryRule abstract class
- Implement TieredDeliveryRule for threshold-based delivery costs
- Support configurable delivery tiers via dependency injection
- Enable easy extension for new delivery rule types"
```

## Strategy Pattern for Offers

```bash
git add lib/offers/
git commit -m "feat: implement promotional offers with Strategy pattern

- Add BaseOffer abstract class for extensibility
- Implement BuyOneGetSecondHalfPrice offer
- Apply pair-based discount logic
- Round intermediate calculations for currency precision"
```

## Basket Implementation

```bash
git add lib/basket.rb
git commit -m "feat: implement Basket class with add and total methods

- Accept catalog, delivery rules, and offers via dependency injection
- Implement add() method for adding products by code
- Implement total() method with offer and delivery calculation
- Calculate totals with proper discount and delivery logic"
```

## Test Suite

```bash
git add spec/
git commit -m "test: add comprehensive RSpec test suite

- Add unit tests for Product, Catalog, and Basket
- Test delivery rules with various thresholds
- Test offer application logic including edge cases
- Verify all provided test cases (B01+G01, R01+R01, etc.)
- Achieve full coverage of business logic"
```

## Documentation and Examples

```bash
git add example_runner.rb README.md
git commit -m "docs: add README and example runner script

- Create comprehensive README with architecture details
- Document design patterns and extensibility
- Add usage examples and test case verification
- Include example_runner.rb for quick demonstration
- Explain design decisions and assumptions"
```

## Push to GitHub

```bash
# Create a new repository on GitHub first, then:
git remote add origin https://github.com/yourusername/acme-widget-co.git
git branch -M main
git push -u origin main
```

## Alternative: Single Commit

If you prefer a simpler approach, you can make a single commit:

```bash
git init
git add .
git commit -m "feat: implement Acme Widget Co basket system

Complete implementation of shopping basket with:
- Product catalog management
- Strategy pattern for delivery rules and offers
- Dependency injection for flexibility
- BigDecimal for currency precision
- Comprehensive test suite with RSpec
- Example runner and documentation

All test cases passing:
- B01, G01 = $37.85 ✓
- R01, R01 = $54.37 ✓
- R01, G01 = $60.85 ✓
- B01, B01, R01, R01, R01 = $98.27 ✓"

git remote add origin https://github.com/yourusername/acme-widget-co.git
git branch -M main
git push -u origin main
```

---

**Note:** The structured commit approach demonstrates better version control practices and makes it easier for reviewers to understand the development progression. However, either approach is valid depending on the context.

