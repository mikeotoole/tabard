# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    event_id 1
    user_profile_id 1
    character_proxy_id 1
    status "MyString"
    is_viewed false
  end
end
