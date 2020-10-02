class Product < ApplicationRecord
  belongs_to :tax_category
  has_many :orders_products
  has_many :orders, through: :orders_products

  monetize :base_price_cents

  def sales_tax_exempt
    return false unless tax_category.present?
    tax_category.sales_tax_exempt
  end

  def sales_tax_exempt?
    sales_tax_exempt
  end

  def price_with_tax
    Money.new(TaxCalculatorService.price_with_tax(self))
  end
end
