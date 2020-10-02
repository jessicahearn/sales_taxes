require 'rails_helper'

RSpec.describe TaxCategory do
  let(:tax_category) { FactoryBot.build(:tax_category) }

  subject { tax_category }

  it { is_expected.to respond_to(:products) }
  it { is_expected.to respond_to(:sales_tax_exempt?) }
end
