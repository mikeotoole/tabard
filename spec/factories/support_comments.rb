# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :support_comment do
    support_ticket
    user_profile
    body "MyText"
  end
end
