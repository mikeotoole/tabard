# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_invite do
    applicant { FactoryGirl.create(:user_profile) }
    sponsor { DefaultObjects.community.admin_profile }
    community { DefaultObjects.community }
  end
end
