# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_upgrade do
    title "MyString"
    description "MyText"
    price_per_month_in_cents 1
    max_number_of_upgrades 1
  end
end
