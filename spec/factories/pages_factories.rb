FactoryGirl.define do    
  factory :page_space do
    sequence(:name) {|n| "Page Space #{n}"}
    user_profile_id { DefaultObjects.user_profile.id }
    community_id { DefaultObjects.community.id }
  end
  
  factory :page_space_for_wow, :parent => :page_space do
    game_id { DefaultObjects.wow.id }
  end
  
  factory :page_space_for_swtor, :parent => :page_space do
    game_id { DefaultObjects.swtor.id }
  end
  
  factory :page do
    sequence(:name) {|n| "Page #{n}"}
    markup "##H2 Heading##\n *Bold*"
    user_profile_id { DefaultObjects.user_profile.id }
    page_space_id { DefaultObjects.page_space.id }
  end
  
  factory :page_by_wow_character, :parent => :page do
    character_proxy_id { Factory.create(:character_proxy_with_wow_character).id }
  end
  
  factory :page_by_swtor_character, :parent => :page do
    character_proxy_id { Factory.create(:character_proxy_with_swtor_character).id }
  end  
end