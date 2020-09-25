class Order < ApplicationRecord
  has_many :orders_products
  has_many :products, through: :orders_products

  def total_tax
    Money.new(TaxCalculatorService.total_tax(self.products))
  end

  def total_cost_with_tax
    Money.new(TaxCalculatorService.total_cost_with_tax(self.products))
  end
end
