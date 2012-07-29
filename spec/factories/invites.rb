# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    event
    user_profile
    is_viewed false
  end

#   factory :invite do
#     event_id { DefaultObjects.event.id }
#     user_profile_id { DefaultObjects.user_profile.id }
#   end
#
#   factory :invite_to_wow_char, :parent => :invite do
#     character_proxy_id { create(:character_proxy_with_wow_character).id }
#   end
#
#   factory :invite_to_swtor_char, :parent => :invite do
#     character_proxy_id { create(:character_proxy_with_swtor_character).id }
#   end
end
