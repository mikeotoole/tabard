# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    user_profile { DefaultObjects.user_profile }
    community { DefaultObjects.community }
    target { DefaultObjects.discussion }
    action "editied"
    deleted_at nil
  end
end
