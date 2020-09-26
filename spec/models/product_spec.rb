require 'rails_helper'

RSpec.describe Product do
  let(:product) { FactoryBot.build(:product, base_price_cents: 500, imported: true) }

  subject { product }

  describe '.sales_tax_exempt' do
    it 'should return true if tax category is exempt' do
      expect(subject.sales_tax_exempt).to eq(true)
    end

    context 'no tax category' do
      before { product.tax_category = nil }

      it 'should return false if no tax category exists' do
        expect(subject.sales_tax_exempt).to eq(false)
      end
    end

    context 'with non-exempt tax category' do
      before { product.tax_category.sales_tax_exempt = false }

      it 'should return false if tax category is non-exempt' do
        expect(subject.sales_tax_exempt).to eq(false)
      end
    end
  end

  describe '.price_with_tax' do
    it 'should return a money object' do
      expect(subject.price_with_tax.is_a?(Money)).to eq(true)
    end

    it 'should have a value of 1050 cents' do
      expect(subject.price_with_tax.cents).to eq(525)
    end

    it 'should use the euro currency symbol' do
      expect(subject.price_with_tax.symbol).to eq('€')
    end
  end
end
