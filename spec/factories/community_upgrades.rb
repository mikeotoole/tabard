# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_upgrade do
    title "MyString"
    description "MyText"
    type "CommunityUserPackUpgrade"
    price_per_month_in_cents 1
    max_number_of_upgrades 1
  end
  factory :twenty_user_pack_upgrade, class: CommunityUpgrade  do
    title "20 Member Pack"
    description "Add room for 20 more members to your Pro Community."
    type "CommunityUserPackUpgrade"
    price_per_month_in_cents 200
    upgrade_options Hash.new(number_of_users: 20)
    max_number_of_upgrades 100
    after(:build) do |upgrade|
      upgrade.upgrade_options = {number_of_users: 20}
    end
  end
end
