# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    event
    user_profile
    is_viewed false
  end
end
