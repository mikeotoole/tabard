FactoryGirl.define do    
  factory :discussion_space do
    sequence(:name) {|n| "Discussion Space #{n}"}
    community_id { DefaultObjects.community.id }
  end
  
  factory :discussion_space_for_wow, :parent => :discussion_space do
    supported_game_id { create(:wow_supported_game).id }
  end
  
  factory :discussion_space_for_swtor, :parent => :discussion_space do
    supported_game_id { create(:swtor_supported_game).id }
  end
  
  factory :discussion do
    sequence(:name) {|n| "Discussion #{n}"}
    sequence(:body) {|n| "Discussion body #{n}"}
    user_profile_id { DefaultObjects.user_profile.id }
    discussion_space_id { DefaultObjects.discussion_space.id }
  end
  
  factory :discussion_by_wow_character, :parent => :discussion do
    character_proxy_id { create(:character_proxy_with_wow_character).id }
  end
  
  factory :discussion_by_swtor_character, :parent => :discussion do
    character_proxy_id { create(:character_proxy_with_swtor_character).id }
  end
  
  factory :comment do
    sequence(:body) {|n| "Comment body #{n}"}
    user_profile_id { DefaultObjects.user_profile.id }
    community_id { DefaultObjects.community.id }
    commentable_id { DefaultObjects.discussion.id }
    commentable_type "Discussion"
    
    factory :comment_with_comment do
      after(:create) { |comment| create(:comment, :commentable_id => comment.id, :commentable_type => "Comment") }
    end
  end

  factory :comment_by_wow_character, :parent => :comment do
    character_proxy_id { create(:character_proxy_with_wow_character).id }
  end

  factory :comment_by_swtor_character, :parent => :comment do
    character_proxy_id { create(:character_proxy_with_swtor_character).id }
  end   
end