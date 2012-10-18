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
  factory :pro_community_plan, class: CommunityPlan do
    title "Pro Community"
    description "Full featured access for up to 100 members."
    price_per_month_in_cents 1000
    is_available true
    max_number_of_users 100
    after(:create) { |community_plan| FactoryGirl.create(:community_plan_upgrade, community_plan_id: community_plan.id, community_upgrade: FactoryGirl.create(:twenty_user_pack_upgrade))}
  end
end
