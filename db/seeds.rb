# Tax Categories
medical = FactoryBot.create(:tax_category, name: 'Medical', sales_tax_exempt: true)
food = FactoryBot.create(:tax_category, name: 'Food', sales_tax_exempt: true)
books = FactoryBot.create(:tax_category, name: 'Books', sales_tax_exempt: true)
music = FactoryBot.create(:tax_category, name: 'Music', sales_tax_exempt: false)
cosmetics = FactoryBot.create(:tax_category, name: 'Cosmetics', sales_tax_exempt: false)

# Orders
order_1 = FactoryBot.create(:order, identifier: '111')
order_2 = FactoryBot.create(:order, identifier: '222')
order_3 = FactoryBot.create(:order, identifier: '333')

# Products for Order #1
order_1.products << FactoryBot.create(:product, name: 'Book', base_price_cents: 1249, tax_category: books, imported: false)
order_1.products << FactoryBot.create(:product, name: 'Music CD', base_price_cents: 1499, tax_category: music, imported: false)
order_1.products << FactoryBot.create(:product, name: 'Chocolate Bar', base_price_cents: 85, tax_category: food, imported: false)

# Products for Order #2
order_2.products << FactoryBot.create(:product, name: 'Imported Box of Chocolates - Value', base_price_cents: 1000, tax_category: food, imported: true)
order_2.products << FactoryBot.create(:product, name: 'Imported Bottle of Perfume - Luxury', base_price_cents: 4750, tax_category: cosmetics, imported: true)

# Products for Order #3
order_3.products << FactoryBot.create(:product, name: 'Imported Bottle of Perfume - Everyday', base_price_cents: 2799, tax_category: cosmetics, imported: true)
order_3.products << FactoryBot.create(:product, name: 'Bottle of Perfume', base_price_cents: 1899, tax_category: cosmetics, imported: false)
order_3.products << FactoryBot.create(:product, name: 'Headache Pills Packet', base_price_cents: 975, tax_category: medical, imported: false)
order_3.products << FactoryBot.create(:product, name: 'Imported Box of Chocolates - Fancy', base_price_cents: 1125, tax_category: food, imported: true)
