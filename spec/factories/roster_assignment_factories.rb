FactoryGirl.define do
  factory :roster_assignment do
    community_profile { FactoryGirl.create(:community_profile_with_supported_games) }
    supported_game { community_profile.community.supported_games.where(:game_type => "Wow").first }
    character_proxy_id { Factory(:character_proxy_with_wow_character).id }
  end
end