FactoryGirl.define do
  factory :swtor do
    faction "Empire"
    server_name "server name"
    server_type "PvE"
  end
  
  factory :wow do
    faction "Alliance"
    server_name "server name"
    server_type "PvE"    
  end
  
  factory :supported_game do
    sequence(:name) {|n| "Supported Game #{n}"}
    community_id { DefaultObjects.community.id }
    game_id { DefaultObjects.wow.id }
    game_type { DefaultObjects.wow.class.name }
  end
  
  factory :supported_game_att, :class => :supported_game do
    sequence(:name) {|n| "Supported Game #{n}"}
    game_type { DefaultObjects.wow.class.name }
    server_name { DefaultObjects.wow.server_name }
    faction { DefaultObjects.wow.faction }
  end
  
  factory :wow_supported_game, :parent => :supported_game do
    game_id { DefaultObjects.wow.id }
    game_type { DefaultObjects.wow.class.name }
  end
  
  factory :swtor_supported_game, :parent => :supported_game do
    game_id { DefaultObjects.swtor.id }
    game_type { DefaultObjects.swtor.class.name }
  end  
end