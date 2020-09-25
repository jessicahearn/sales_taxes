FactoryBot.define do
  factory :tax_category do
    name { 'Medical' }
    sales_tax_exempt { true }
  end
end
