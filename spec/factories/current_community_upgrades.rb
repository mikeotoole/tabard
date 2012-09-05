# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :current_community_upgrade do
    community
    community_upgrade { (community.blank? ? FactoryGirl.create(:community_upgrade) : community.community_plan.community_upgrades.first) }
    number_in_use 1
  end
end
