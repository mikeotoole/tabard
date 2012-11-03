FactoryGirl.define do
  # Create a basic user.
  factory :user do
    password "Password"
    confirmed_at { 1.day.ago }
    sequence(:email) {|n| "person#{n}@example.com"}
    email_confirmation { email }
    date_of_birth 35.years.ago.to_date
    user_profile_attributes { FactoryGirl.attributes_for(:user_profile) }
    time_zone -8
    terms "1"
  end

  factory :disabled_user, :parent => :user do
    after(:create) do |u|
      u.disable_by_admin
    end
  end

  # Create an active user with full associations.
  factory :billy, :class => User do
    password "Password"
    time_zone -8
    confirmed_at { 1.day.ago }
    email "billy@robo.com"
    email_confirmation "billy@robo.com"
    user_profile_attributes { FactoryGirl.attributes_for(:user_profile, :display_name => "Robobilly", :full_name => "Robo Billy") }
    date_of_birth 35.years.ago.to_date
    terms "1"
    after(:create) do |u|
      FactoryGirl.create(:swtor_character, :user_profile => u.user_profile)
    end
  end

  factory :community_admin, :parent => :user do
    after(:create) do |u|
      FactoryGirl.create(:community, :admin_profile_id => u.user_profile_id)
    end
  end
end
