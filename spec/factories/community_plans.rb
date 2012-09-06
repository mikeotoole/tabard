# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_plan do
    title "Plan Title"
    description "Plan Description"
    price_per_month_in_cents 0
    max_number_of_users 20
    is_available true
    after(:create) { |community_plan| FactoryGirl.create(:community_plan_upgrade, :community_plan_id => community_plan.id) }
  end
end
