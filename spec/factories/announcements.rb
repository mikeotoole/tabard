# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
  	community
    name "MyString"
    body "MyText"
    user_profile { community.admin_profile}
    is_locked false
    has_been_edited false
  end
end
