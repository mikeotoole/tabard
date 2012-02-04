FactoryGirl.define do
  # Create a basic user.
  factory :user do
    password "Password"
    password_confirmation "Password"
    confirmed_at { 1.day.ago }
    sequence(:email) {|n| "person#{n}@example.com"}
    accepted_current_terms_of_service true
    accepted_current_privacy_policy true
    date_of_birth 35.years.ago.to_date
    user_profile_attributes { FactoryGirl.attributes_for(:user_profile) }
  end

  # Create an active user with full associations.
  factory :billy, :class => User do
    password "Password"
    password_confirmation "Password"
    confirmed_at { 1.day.ago }
    email "billy@robo.com"
    user_profile_attributes { FactoryGirl.attributes_for(:user_profile, :display_name => "Robobilly", :first_name => "Robo", :last_name => "Billy") }
    accepted_current_terms_of_service true
    accepted_current_privacy_policy true
    date_of_birth 35.years.ago.to_date
    after_create do |u|
      FactoryGirl.create(:character_proxy_with_swtor_character, :user_profile => u.user_profile)
    end
  end

  factory :community_admin, :parent => :user do
    after_create do |u|
      FactoryGirl.create(:community, :admin_profile_id => u.user_profile_id)
    end
  end
end
