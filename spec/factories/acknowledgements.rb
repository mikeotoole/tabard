# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :acknowledgement do
    community_profile_id 1
    announcement_id 1
    has_been_viewed false
  end
end
