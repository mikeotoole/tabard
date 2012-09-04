# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_plan_upgrade do
    community_plan
    community_upgrade
  end
end
