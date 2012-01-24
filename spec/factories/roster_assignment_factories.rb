FactoryGirl.define do
  factory :roster_assignment do
    community_profile
    supported_game { DefaultObjects.community.supported_games.first }
    character_proxy_id { Factory(:character_proxy_with_wow_character).id }
  end
end