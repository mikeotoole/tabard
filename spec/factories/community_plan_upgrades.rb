# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_plan_upgrade, :class => 'CommunityPlanUpgrades' do
    community_plan_id 1
    community_upgrade_id 1
  end
end
