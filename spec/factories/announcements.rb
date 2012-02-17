# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
  	community
    name "MyString"
    body "MyText"
    user_profile { community.admin_profile if community}
    is_locked false
    has_been_edited false
    
    factory :announcement_for_wow do
      community { DefaultObjects.community }
      supported_game { community.supported_games.where(:game_type => "Wow").first }
    end
    
    factory :announcement_for_swtor do
      community { DefaultObjects.community }
      supported_game { community.supported_games.where(:game_type => "Swtor").first }
    end
  end
end
