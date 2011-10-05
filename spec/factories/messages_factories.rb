FactoryGirl.define do
  factory :message do
    subject "Message Subject"
    body "Message Body"
    author_id { DefaultObjects.user_profile.id }
    to { [DefaultObjects.additional_community_user_profile] }
  end
  
  factory :message_with_muti_to, :parent => :message do
    to { [DefaultObjects.additional_community_user_profile, DefaultObjects.community_admin.user_profile] }
  end
  
  factory :folder do
    sequence(:name) {|n| "Folder #{n}"} 
    user_profile_id { DefaultObjects.user_profile.id }
  end
end