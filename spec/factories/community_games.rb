# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_game do
    community_id 1
    game_id 1
    game_announcement_space_id 1
    info "MyText"
  end
end
