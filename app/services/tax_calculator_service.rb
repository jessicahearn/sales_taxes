module TaxCalculatorService
  SALES_TAX_MULTIPLIER = 0.1
  IMPORT_TAX_MULTIPLIER = 0.05

  # All amounts are handled and returned in cents (e.g. 100 vs. 1.00)

  def self.sales_tax(product)
    return 0 if product.sales_tax_exempt
    round_tax(product.base_price_cents * SALES_TAX_MULTIPLIER)
  end

  def self.import_tax(product)
    return 0 unless product.imported
    round_tax(product.base_price_cents * IMPORT_TAX_MULTIPLIER)
  end

  def self.combined_tax(product)
    sales_tax(product) + import_tax(product)
  end

  def self.price_with_tax(product)
    product.base_price_cents + combined_tax(product)
  end

  def self.total_cost_base(products = [])
    products.map(&:base_price_cents).sum
  end

  def self.total_tax(products = [])
    products.map { |p| combined_tax(p) }.sum
  end

  def self.total_cost_with_tax(products = [])
    products.map { |p| price_with_tax(p) }.sum
  end

  private

  def self.round_tax(tax)
    # Taxes must be rounded to the nearest 0.05
    (tax/5.0).ceil * 5
  end
end
