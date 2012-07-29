FactoryGirl.define do    
  factory :page_space do
    sequence(:name) {|n| "Page Space #{n}"}
    community_id { DefaultObjects.community.id }
  end
  
  factory :page_space_for_wow, :parent => :page_space do
    supported_game_id { create(:wow_supported_game).id }
  end
  
  factory :page_space_for_swtor, :parent => :page_space do
    supported_game_id { create(:swtor_supported_game).id }
  end
  
  factory :page do
    sequence(:name) {|n| "Page #{n}"}
    markup "##H2 Heading##\n *Bold*"
    page_space_id { DefaultObjects.page_space.id }
  end 
end