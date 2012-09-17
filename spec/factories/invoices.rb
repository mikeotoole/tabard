# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    stripe_invoice_id "MyString"
    period_start_date "2012-09-15 09:54:11"
    period_end_date "2012-09-15 09:54:11"
    date_paid "2012-09-15 09:54:11"
    stripe_customer_id "MyString"
    discount_percent_off 1
    discount_discription "MyString"
  end
end
