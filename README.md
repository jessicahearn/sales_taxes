# README

This project demonstrates a simple tax calculator service that can be used to calculate sales and import taxes for individual items within an order, display prices with tax included, and sum both taxes and prices with tax included for an entire order.

## Setup

You must have postgres installed to run this project. Once that's done, run the following commands.

`bundle exec rake db:create`

`bundle exec rake db:migrate`

`bundle exec rake db:seed`

The site can be viewed at `localhost:3000`

## Notes

My approach here is to centralize the tax calculations in one location so that any future changes to tax rates can be made painlessly, without a lot of refactoring elsewhere. The methods of the TaxCalculatorService all expect either a single product or an array of products as arguments, which means that the TaxCalculatorService is currently aware of the available methods on the product model. If, at some point in the future, the TaxCalculatorService needed to be further generalized to deal with other less predictable types of objects (e.g. variants of products, or products with different pricing models like subscription services), it would not be difficult to convert it to accept raw values instead -- but for the time being this approach is the most straightforward option.

I've also chosen to handle sales tax exemptions by assigning products to TaxCategories. While the simplest solution would be to put a boolean flag for sales tax exemption directly on the product model, as with the import flag, this approach accounts for the possibility that in the future, categories that are not currently tax exempt might become tax exempt, or vice versa. With this architecture, reacting to those changes would be as simple as toggling the flag on the tax category object, as opposed to finding and changing all applicable products individually.
