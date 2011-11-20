FactoryGirl.define do
  factory :swtor do
    faction "Sith"
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
    association :game, :factory => :wow
  end
  
  factory :wow_supported_game, :parent => :supported_game do
    association :game, :factory => :wow
  end
  
  factory :swtor_supported_game, :parent => :supported_game do
    association :game, :factory => :swtor
  end  
end