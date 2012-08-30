# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :current_community_upgrade do
    community
    community_upgrade
    number_in_use 1
  end
end
