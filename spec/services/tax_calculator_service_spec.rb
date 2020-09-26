require 'rails_helper'

RSpec.describe TaxCalculatorService do
  # Tax Categories
  let(:medical) { FactoryBot.create(:tax_category, name: 'Medical', sales_tax_exempt: true) }
  let(:food) { FactoryBot.create(:tax_category, name: 'Food', sales_tax_exempt: true) }
  let(:books) { FactoryBot.create(:tax_category, name: 'Books', sales_tax_exempt: true) }
  let(:music) { FactoryBot.create(:tax_category, name: 'Music', sales_tax_exempt: false) }
  let(:cosmetics) { FactoryBot.create(:tax_category, name: 'Cosmetics', sales_tax_exempt: false) }

  let!(:order_1) { FactoryBot.create(:order, identifier: '111') }
  let!(:order_2) { FactoryBot.create(:order, identifier: '222') }
  let!(:order_3) { FactoryBot.create(:order, identifier: '333') }

  before do
    # Products for Order 1
    order_1.products << FactoryBot.create(:product, name: 'Book', base_price_cents: 1249, tax_category: books, imported: false)
    order_1.products << FactoryBot.create(:product, name: 'Music CD', base_price_cents: 1499, tax_category: music, imported: false)
    order_1.products << FactoryBot.create(:product, name: 'Chocolate Bar', base_price_cents: 85, tax_category: food, imported: false)

    # Products for Order 2
    order_2.products << FactoryBot.create(:product, name: 'Imported Box of Chocolates - Value', base_price_cents: 1000, tax_category: food, imported: true)
    order_2.products << FactoryBot.create(:product, name: 'Imported Bottle of Perfume - Luxury', base_price_cents: 4750, tax_category: cosmetics, imported: true)

    # Products for Order 3
    order_3.products << FactoryBot.create(:product, name: 'Imported Bottle of Perfume - Everyday', base_price_cents: 2799, tax_category: cosmetics, imported: true)
    order_3.products << FactoryBot.create(:product, name: 'Bottle of Perfume', base_price_cents: 1899, tax_category: cosmetics, imported: false)
    order_3.products << FactoryBot.create(:product, name: 'Headache Pills Packet', base_price_cents: 975, tax_category: medical, imported: false)
    order_3.products << FactoryBot.create(:product, name: 'Imported Box of Chocolates - Fancy', base_price_cents: 1125, tax_category: food, imported: true)
  end

  subject { TaxCalculatorService }

  # All other methods in this service are used in the process of testing these four methods, and
  # these methods can directly test all of the key information displayed on user-facing pages.
  # Note that this service handles all amounts in cents, so all numbers being tested here are integers.

  describe '.price_with_tax' do
    # Products for Order 1
    # Only one product in this order is subject to sales tax, and none are imported.
    it 'should return base price with no tax for order 1 product 1' do
      expect(subject.price_with_tax(order_1.products.first)).to eq(1249)
    end
    it 'should return base price + sales tax for order 1 product 2' do
      expect(subject.price_with_tax(order_1.products.second)).to eq(1649)
    end
    it 'should return base price for order 1 product 3' do
      expect(subject.price_with_tax(order_1.products.third)).to eq(85)
    end

    # Products for Order 2
    # Both products in this order are imported, and one is subject to sales tax.
    it 'should return base price + import tax for order 2 product 1' do
      expect(subject.price_with_tax(order_2.products.first)).to eq(1050)
    end
    it 'should return base price + sales tax + import tax for order 2 product 2' do
      expect(subject.price_with_tax(order_2.products.second)).to eq(5465)
    end

    # Products for Order 3
    # This order includes one product each for each possible scenario:
    # - Sales Tax + Import Tax
    # - Sales Tax Only
    # - No Tax
    # - Import Tax Only
    it 'should return base price + sales tax + import tax for order 3 product 1' do
      expect(subject.price_with_tax(order_3.products.first)).to eq(3219)
    end
    it 'should return base price + sales tax for order 3 product 2' do
      expect(subject.price_with_tax(order_3.products.second)).to eq(2089)
    end
    it 'should return base price for order 3 product 3' do
      expect(subject.price_with_tax(order_3.products.third)).to eq(975)
    end
    it 'should return base price + import tax for order 3 product 4' do
      expect(subject.price_with_tax(order_3.products.fourth)).to eq(1185)
    end
  end

  describe '.total_cost_base' do
    # This method returns the sum of all product prices in a given order, excluding tax
    it { expect(subject.total_cost_base(order_1.products)).to eq(2833) }
    it { expect(subject.total_cost_base(order_2.products)).to eq(5750) }
    it { expect(subject.total_cost_base(order_3.products)).to eq(6798) }
  end

  describe '.total_tax' do
    # This method returns the sum of all taxes for products in a given order
    it { expect(subject.total_tax(order_1.products)).to eq(150) }
    it { expect(subject.total_tax(order_2.products)).to eq(765) }
    it { expect(subject.total_tax(order_3.products)).to eq(670) }
  end

  describe '.total_cost_with_tax' do
    # This method returns the sum of all product prices in a given order, including tax
    it { expect(subject.total_cost_with_tax(order_1.products)).to eq(2983) }
    it { expect(subject.total_cost_with_tax(order_2.products)).to eq(6515) }
    it { expect(subject.total_cost_with_tax(order_3.products)).to eq(7468) }
  end
end
