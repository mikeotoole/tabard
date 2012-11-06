FactoryGirl.define do
  factory :swtor do
    name "Star Wars: The Old Republic"
  end

  factory :wow do
    name "World of Warcraft"
  end

  factory :community_game do
    community_id { DefaultObjects.community.id }
    game_id { DefaultObjects.wow.id }
  end

  factory :community_game_att, :class => :community_game do
    game_name { "World of Warcraft" }
    faction { "Hord" }
    server_name { "Aegwynn" }
  end

  factory :wow_community_game, :parent => :community_game do
    game { DefaultObjects.wow }
  end

  factory :swtor_community_game, :parent => :community_game do
    game { DefaultObjects.swtor }
  end
end
