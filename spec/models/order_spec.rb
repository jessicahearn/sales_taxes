require 'rails_helper'

RSpec.describe Order do
  let(:order) { FactoryBot.build(:order) }
  let(:products) { FactoryBot.build_list(:product, 2, base_price_cents: 500, imported: true) }

  subject { order }

  before do
    order.products << products
  end

  it { is_expected.to respond_to(:identifier) }
  it { is_expected.to respond_to(:products) }

  context 'with 2 products at 500 cents each' do
    context 'both imported' do
      context 'and both tax exempt' do
        describe '#total_tax' do
          it 'returns a money object' do
            expect(subject.total_tax.is_a?(Money)).to eq(true)
          end

          it 'has a value of 50 cents (import tax * 2 products)' do
            expect(subject.total_tax.cents).to eq(50)
          end

          it 'uses the euro currency symbol' do
            expect(subject.total_tax.symbol).to eq('€')
          end
        end

        describe '#total_cost_with_tax' do
          it 'returns a money object' do
            expect(subject.total_cost_with_tax.is_a?(Money)).to eq(true)
          end

          it 'has a value of 1050 cents ((base price + import tax) * 2 products)' do
            expect(subject.total_cost_with_tax.cents).to eq(1050)
          end

          it 'uses the euro currency symbol' do
            expect(subject.total_cost_with_tax.symbol).to eq('€')
          end
        end
      end

      context 'and neither tax exempt' do
        before { products.map { |p| p.tax_category.sales_tax_exempt = false } }

        describe '#total_tax' do
          it 'returns a money object' do
            expect(subject.total_tax.is_a?(Money)).to eq(true)
          end

          it 'has a value of 150 cents ((import tax + sales tax) * 2 products)' do
            expect(subject.total_tax.cents).to eq(150)
          end

          it 'uses the euro currency symbol' do
            expect(subject.total_tax.symbol).to eq('€')
          end
        end

        describe '#total_cost_with_tax' do
          it 'returns a money object' do
            expect(subject.total_cost_with_tax.is_a?(Money)).to eq(true)
          end

          it 'has a value of 1150 cents ((base price + import tax + sales tax) * 2 products)' do
            expect(subject.total_cost_with_tax.cents).to eq(1150)
          end

          it 'uses the euro currency symbol' do
            expect(subject.total_cost_with_tax.symbol).to eq('€')
          end
        end
      end
    end
  end
end
