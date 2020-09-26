require 'rails_helper'

RSpec.describe Order do
  let(:order) { FactoryBot.build(:order) }
  let(:products) { FactoryBot.build_list(:product, 2, base_price_cents: 500, imported: true) }

  subject { order }

  before do
    order.products << products
  end

  describe '.total_tax' do
    it 'should return a money object' do
      expect(subject.total_tax.is_a?(Money)).to eq(true)
    end

    it 'should have a value of 50 cents' do
      expect(subject.total_tax.cents).to eq(50)
    end

    it 'should use the euro currency symbol' do
      expect(subject.total_tax.symbol).to eq('€')
    end
  end

  describe '.total_cost_with_tax' do
    it 'should return a money object' do
      expect(subject.total_cost_with_tax.is_a?(Money)).to eq(true)
    end

    it 'should have a value of 1050 cents' do
      expect(subject.total_cost_with_tax.cents).to eq(1050)
    end

    it 'should use the euro currency symbol' do
      expect(subject.total_cost_with_tax.symbol).to eq('€')
    end
  end
end
