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

  context 'when given a single product' do
    it 'calculates the import tax' do
      should respond_to(:import_tax)
    end

    it 'calculates the sales tax' do
      should respond_to(:sales_tax)
    end

    it 'calculates the combined tax' do
      should respond_to(:combined_tax)
    end

    it 'calculates the price with tax' do
      should respond_to(:price_with_tax)
    end
  end

  context 'when given an array of products' do
    it 'calculates the total base cost' do
      should respond_to(:total_cost_base)
    end

    it 'calculates the total tax' do
      should respond_to(:total_tax)
    end

    it 'calculates the total cost with tax' do
      should respond_to(:total_cost_with_tax)
    end
  end

  context 'Test Order 1' do
    context 'Product 1' do
      describe '.price_with_tax' do
        it 'returns 1249 cents (base price + 0 tax)' do
          expect(subject.price_with_tax(order_1.products.first)).to eq(1249)
        end
      end
    end

    context 'Product 2' do
      describe '.price_with_tax' do
        it 'returns 1649 cents (base price + sales tax)' do
          expect(subject.price_with_tax(order_1.products.second)).to eq(1649)
        end
      end
    end

    context 'Product 3' do
      describe '.price_with_tax' do
        it 'returns 85 cents (base price + 0 tax)' do
          expect(subject.price_with_tax(order_1.products.third)).to eq(85)
        end
      end
    end

    describe '.total_cost_base' do
      it 'returns 2833 cents (sum of base prices)' do
        expect(subject.total_cost_base(order_1.products)).to eq(2833)
      end
    end

    describe '.total_tax' do
      it 'returns 150 cents (sum of all taxes)' do
        expect(subject.total_tax(order_1.products)).to eq(150)
      end
    end

    describe '.total_cost_with_tax' do
      it 'returns 2983 cents (total cost base + total tax)' do
        expect(subject.total_cost_with_tax(order_1.products)).to eq(2983)
      end
    end
  end

  context 'Test Order 2' do
    context 'Product 1' do
      describe '.price_with_tax' do
        it 'returns 1050 cents (base price + import tax)' do
          expect(subject.price_with_tax(order_2.products.first)).to eq(1050)
        end
      end
    end

    context 'Product 2' do
      describe '.price_with_tax' do
        it 'returns 5465 cents (base price + sales tax + import tax)' do
          expect(subject.price_with_tax(order_2.products.second)).to eq(5465)
        end
      end
    end

    describe '.total_cost_base' do
      it 'returns 5750 cents (sum of base prices)' do
        expect(subject.total_cost_base(order_2.products)).to eq(5750)
      end
    end

    describe '.total_tax' do
      it 'returns 765 cents (sum of all taxes)' do
        expect(subject.total_tax(order_2.products)).to eq(765)
      end
    end

    describe '.total_cost_with_tax' do
      it 'returns 6515 cents (total_cost_base + total_tax)' do
        expect(subject.total_cost_with_tax(order_2.products)).to eq(6515)
      end
    end
  end

  context 'Test Order 3' do
    context 'Product 1' do
      describe '.price_with_tax' do
        it 'returns 3219 cents (base price + sales tax + import tax)' do
          expect(subject.price_with_tax(order_3.products.first)).to eq(3219)
        end
      end
    end

    context 'Product 2' do
      describe '.price_with_tax' do
        it 'returns 2089 cents (base price + sales tax)' do
          expect(subject.price_with_tax(order_3.products.second)).to eq(2089)
        end
      end
    end

    context 'Product 3' do
      describe '.price_with_tax' do
        it 'returns 975 cents (base price + 0 tax)' do
          expect(subject.price_with_tax(order_3.products.third)).to eq(975)
        end
      end
    end

    context 'Product 4' do
      describe '.price_with_tax' do
        it 'returns 1185 cents (base price + import tax)' do
          expect(subject.price_with_tax(order_3.products.fourth)).to eq(1185)
        end
      end
    end

    describe '.total_cost_base' do
      it 'returns 6798 cents (sum of base prices)' do
        expect(subject.total_cost_base(order_3.products)).to eq(6798)
      end
    end

    describe '.total_tax' do
      it 'returns 670 cents (sum of all taxes)' do
        expect(subject.total_tax(order_3.products)).to eq(670)
      end
    end

    describe '.total_cost_with_tax' do
      it 'returns 7468 cents (total_cost_base + total_tax)' do
        expect(subject.total_cost_with_tax(order_3.products)).to eq(7468)
      end
    end
  end
end
