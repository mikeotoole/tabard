# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    user_profile_id 1
    community_id 1
    target_type "MyString"
    target_id 1
    action "MyString"
    deleted_at ""
  end
end
