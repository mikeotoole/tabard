FactoryGirl.define do
  factory :roster_assignment do
    community_profile { FactoryGirl.create(:community_profile_with_community_games) }
    community_game { community_profile.community.community_games.where(:game_type => "Wow").first }
    character_proxy_id { create(:character_proxy_with_wow_character).id }
  end
end