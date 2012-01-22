FactoryGirl.define do
  # Create a basic community.
  factory :community_application do
    community { DefaultObjects.community }
    user_profile { DefaultObjects.fresh_user_profile }
    submission { FactoryGirl.create(:submission, :custom_form => DefaultObjects.community.community_application_form, :user_profile => DefaultObjects.fresh_user_profile) }
    character_proxies { DefaultObjects.fresh_user_profile.character_proxies }
    
    factory :community_application_with_comment do
      after_create { |community_application| FactoryGirl.create(:comment, :commentable_id => community_application.id, :commentable_type => "CommunityApplication") }
    end
  end
end
