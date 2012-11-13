FactoryGirl.define do
  factory :swtor_character do
    sequence(:name) {|n| "SWTOR Character #{n}" }
    char_class "Bounty Hunter"
    faction "Empire"
    advanced_class "Powertech"
    species "Cyborg"
    gender "Male"
    level 20

    after(:build) do |character|
      if character.user_profile
        character.played_game = FactoryGirl.create(:swtor_played_game, :user_profile => character.user_profile)
      else
        character.played_game = FactoryGirl.create(:swtor_played_game)
      end
    end

    factory :swtor_character_with_images do
      avatar { File.open("#{Rails.root}/spec/testing_files/goodAvatar1.jpg") }
    end
  end

  factory :swtor_character_att, :class => :swtor_character do
    sequence(:name) {|n| "SWTOR Character #{n}" }
    server_name { DefaultObjects.swtor.server_names.first }
    char_class "Bounty Hunter"
    faction "Empire"
    advanced_class "Powertech"
    species "Cyborg"
    gender "Male"
    level 20
  end

  factory :wow_character do
    sequence(:name) {|n| "WOWChar #{n}" }
    faction { DefaultObjects.wow.factions.first }
    server_name { DefaultObjects.wow.server_names.first }
    char_class "Mage"
    race "Human"
    level 20
    gender "Male"

    after(:build) do |character|
      if character.user_profile
        character.played_game = FactoryGirl.create(:wow_played_game, :user_profile => character.user_profile)
      else
        character.played_game = FactoryGirl.create(:wow_played_game)
      end
    end

    factory :wow_character_with_images do
      avatar { File.open("#{Rails.root}/spec/testing_files/goodAvatar1.jpg") }
    end
  end

  factory :wow_character_att, :class => :wow_character do
    sequence(:name) {|n| "WOWChar #{n}" }
    faction { DefaultObjects.wow.factions.first }
    server_name { DefaultObjects.wow.server_names.first }
    char_class "Mage"
    race "Human"
    level 20
    gender "Male"
  end

  factory :minecraft_character do
    # TODO: Need to be able to pass a user_profile to this... -MO
    association :played_game, factory: :minecraft_played_game
    sequence(:name) {|n| "MC Character #{n}" }
  end
end
