FactoryGirl.define do
  # Create a basic community profile.
  factory :community_profile do
    user_profile
    community
    roles { [community.member_role] }
  end

  factory :community_profile_with_nil_community, :parent => :community_profile do
    after_build do |profile|
      profile.update_attribute(:community, nil)
    end
  end
  factory :community_profile_with_characters, :parent => :community_profile do
    user_profile { create(:user_profile_with_characters) }
  end
end
