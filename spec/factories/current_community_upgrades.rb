# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :current_community_upgrade, :class => 'CurrentCommunityUpgrades' do
    community_id 1
    community_upgrade_id 1
    number_in_use 1
  end
end
