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
      community_game { community.community_games.where(:game_id => DefaultObjects.wow.id).first }
    end

    factory :announcement_for_swtor do
      community { DefaultObjects.community }
      community_game { community.community_games.where(:game_id => DefaultObjects.swtor.id).first }
    end
  end
end
