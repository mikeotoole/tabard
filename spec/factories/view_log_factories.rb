FactoryGirl.define do
  factory :view_log do
    user_profile_id { DefaultObjects.user_profile.id }
    view_loggable_id { FactoryGirl.create(:discussion).id }
    view_loggable_type "Discussion"
  end
end