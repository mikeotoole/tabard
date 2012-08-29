# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_plan do
    title "MyString"
    description "MyText"
    price_per_month_in_cents 1
    is_available false
  end
end
