FactoryGirl.define do
  factory :swtor_character do
    sequence(:name) {|n| "SWTOR Character #{n}" }
    swtor
    server "Default SWTOR Server"
  end
  
  factory :wow_character do
    sequence(:name) {|n| "WOW Character #{n}" }
    wow
    server "Default WOW Server"
    faction "Horde"
    race "Goblin"
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
  
  factory :character_proxy_with_user_profile, :class => CharacterProxy do
    user_profile { DefaultObjects.user_profile }
  end
  
  factory :character_proxy_with_wow_character, :class => CharacterProxy do
    association :character, :factory => :wow_character 
  end
  
  factory :character_proxy_with_swtor_character, :class => CharacterProxy do
    association :character, :factory => :swtor_character 
  end
end

def set_character_proxy(character)
  character.character_proxy = FactoryGirl.create(:character_proxy_with_user_profile, :character => character)
end
