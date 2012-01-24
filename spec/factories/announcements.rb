# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
    name "MyString"
    body "MyText"
    character_proxy_id 1
    user_profile_id 1
    is_locked false
    deleted_at "2012-01-24 15:15:58"
    has_been_edited false
  end
end
