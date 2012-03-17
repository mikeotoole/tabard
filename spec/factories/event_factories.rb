FactoryGirl.define do
  factory :event do
    sequence(:title) {|n| "Event #{n}"}
    body "Event Body"
    start_time { Time.now + (60 * 60) }
    end_time { Time.now + (120 * 60) }
    creator_id { DefaultObjects.community_admin.user_profile_id }
    community_id { DefaultObjects.community.id }
  end
  
  factory :wow_event, :parent => :event do
    supported_game_id { Factory.create(:wow_supported_game).id }
  end

  factory :swtor_event, :parent => :event do
    supported_game_id { Factory.create(:swtor_supported_game).id }
  end
  
  factory :private_event, :parent => :event do
    is_private { true }
  end
  
#   factory :invite do
#     event_id { DefaultObjects.event.id }
#     user_profile_id { DefaultObjects.user_profile.id }
#   end
#   
#   factory :invite_to_wow_char, :parent => :invite do
#     character_proxy_id { Factory.create(:character_proxy_with_wow_character).id }
#   end
#   
#   factory :invite_to_swtor_char, :parent => :invite do
#     character_proxy_id { Factory.create(:character_proxy_with_swtor_character).id }
#   end
end