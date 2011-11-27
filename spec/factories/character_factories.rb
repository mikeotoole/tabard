FactoryGirl.define do
  factory :swtor_character do
    sequence(:name) {|n| "SWTOR Character #{n}" }
    swtor { DefaultObjects.swtor }
    char_class "Bounty Hunter"
    species "Cyborg"
    level 20
  end

  factory :swtor_character_att, :class => :swtor_character do
    sequence(:name) {|n| "SWTOR Character #{n}" }
    faction { DefaultObjects.swtor.faction }
    server_name { DefaultObjects.swtor.server_name }
    char_class "Bounty Hunter"
    species "Cyborg"
    level 20
  end
  
  factory :wow_character do
    sequence(:name) {|n| "WOW Character #{n}" }
    wow { DefaultObjects.wow }
    char_class "Mage"
    race "Human"
    level 20
  end

  factory :wow_character_att, :class => :wow_character do
    sequence(:name) {|n| "WOW Character #{n}" }
    faction { DefaultObjects.wow.faction }
    server_name { DefaultObjects.wow.server_name }
    char_class "Mage"
    race "Human"
    level 20
  end
  
  # wow character with default user profile
  factory :wow_char_profile, :parent => :wow_character do
    after_create { |c| set_character_proxy(c) }
  end
  
  # swtor character with default user profile
  factory :swtor_char_profile, :parent => :swtor_character do
    after_create { |c| set_character_proxy(c) }
  end
  
  factory :character_proxy do
    user_profile { DefaultObjects.user_profile }
    association :character, :factory => :wow_character
  end
  
  factory :character_proxy_with_wow_character, :class => CharacterProxy do
    user_profile { DefaultObjects.user_profile }
    association :character, :factory => :wow_character 
  end
  
  factory :character_proxy_with_swtor_character, :class => CharacterProxy do
    user_profile { DefaultObjects.user_profile }
    association :character, :factory => :swtor_character 
  end
end

def set_character_proxy(character)
  FactoryGirl.create(:character_proxy, :character => character)
end
