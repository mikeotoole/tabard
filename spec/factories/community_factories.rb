FactoryGirl.define do
  # Create a basic community.
  factory :community do
    sequence(:name) {|n| "Community #{n}"}
    slogan "Default Community Slogan"
    admin_profile_id { FactoryGirl.create(:user_profile).id }
  end
end
