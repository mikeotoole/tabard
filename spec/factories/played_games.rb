# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wow_played_game, class: :played_game do
    game_id { DefaultObjects.wow.id }
    user_profile_id { DefaultObjects.user_profile.id }
  end

  factory :swtor_played_game, class: :played_game do
    game_id { DefaultObjects.swtor.id }
    user_profile_id { DefaultObjects.user_profile.id }
  end

  factory :minecraft_played_game, class: :played_game do
    game_id { DefaultObjects.minecraft.id }
    user_profile_id { DefaultObjects.user_profile.id }
  end
end
