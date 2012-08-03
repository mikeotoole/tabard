# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_invite do
    applicant_id 1
    sponser_id 1
    community_id 1
  end
end
