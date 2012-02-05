# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
  	community
    name "MyString"
    body "MyText"
    user_profile { community.admin_profile}
    is_locked false
    deleted_at "2012-01-24 15:15:58"
    has_been_edited false
  end
end
