class Product < ApplicationRecord
  belongs_to :tax_category
  has_many :orders_products
  has_many :orders, through: :orders_products

  delegate :sales_tax_exempt, to: :tax_category

  monetize :base_price_cents

  def price_with_tax
    Money.new(TaxCalculatorService.price_with_tax(self))
  end
end
