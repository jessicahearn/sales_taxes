require 'rails_helper'

RSpec.describe Product do
  let(:product) { FactoryBot.build(:product, base_price_cents: 500, imported: true) }

  subject { product }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:base_price_cents) }
  it { is_expected.to respond_to(:orders) }
  it { is_expected.to respond_to(:tax_category) }
  it { is_expected.to respond_to(:imported?) }
  it { is_expected.to respond_to(:sales_tax_exempt?) }

  context 'with a tax category' do
    context 'that is tax exempt' do
      describe '#sales_tax_exempt' do
        it 'returns true' do
          expect(subject.sales_tax_exempt).to eq(true)
        end
      end
    end

    context 'that is non-exempt' do
      before { product.tax_category.sales_tax_exempt = false }

      describe '#sales_tax_exempt' do
        it 'returns false' do
          expect(subject.sales_tax_exempt).to eq(false)
        end
      end
    end
  end

  context 'with no tax category' do
    before { product.tax_category = nil }

    describe '#sales_tax_exempt' do
      it 'returns false' do
        expect(subject.sales_tax_exempt).to eq(false)
      end
    end
  end

  context 'with a base price of 500 cents' do
    context 'that is imported' do
      context 'and is tax exempt' do
        describe '#price_with_tax' do
          it 'returns a money object' do
            expect(subject.price_with_tax.is_a?(Money)).to eq(true)
          end

          it 'has a value of 525 cents (base price + import tax)' do
            expect(subject.price_with_tax.cents).to eq(525)
          end

          it 'uses the euro currency symbol' do
            expect(subject.price_with_tax.symbol).to eq('€')
          end
        end
      end

      context 'and is non-exempt' do
        before { product.tax_category.sales_tax_exempt = false }

        describe '#price_with_tax' do
          it 'returns a money object' do
            expect(subject.price_with_tax.is_a?(Money)).to eq(true)
          end

          it 'has a value of 575 cents (base price + import tax + sales tax)' do
            expect(subject.price_with_tax.cents).to eq(575)
          end

          it 'uses the euro currency symbol' do
            expect(subject.price_with_tax.symbol).to eq('€')
          end
        end
      end
    end
  end
end
