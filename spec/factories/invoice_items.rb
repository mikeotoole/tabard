# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice_item do
    amount 1
    date "2012-09-15 09:59:05"
    discription "MyString"
    item_type "MyString"
    item_id 1
    count 1
    invoice_id 1
  end
end
