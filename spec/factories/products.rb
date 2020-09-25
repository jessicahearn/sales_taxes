FactoryBot.define do
  factory :product do
    name { 'Product Name' }
    base_price_cents { 500 }
    imported { false }
    association :tax_category, strategy: :build
  end
end
