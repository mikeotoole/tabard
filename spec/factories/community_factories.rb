FactoryGirl.define do
  # Create a basic community.
  factory :community do
    sequence(:name) {|n| "Community #{n}"}
    slogan "Default Community Slogan"
    pitch "Default Community Pitch"
    admin_profile_id { FactoryGirl.create(:user_profile).id }
  end
  factory :community_with_supported_games, :parent => :community do
    sequence(:name) {|n| "Community #{n}"}
    slogan "Default Community Slogan"
    admin_profile
    after(:create) do |community|
      FactoryGirl.create(:wow_supported_game, :community_id => community.id)
      FactoryGirl.create(:swtor_supported_game, :community_id => community.id)
    end
  end
end