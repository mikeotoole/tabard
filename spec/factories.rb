FactoryGirl.define do
  # Create a sequence of usernames for user profle.
  sequence :first_name do |n|
    "FirstName#{n}"
  end
  sequence :last_name do |n|
    "LastName#{n}"
  end

  # Create a sequence of names for community.
  sequence :name do |n|
    "Name#{n}"
  end

  # Create a sequence of emails.
  sequence :email do |n|
    "person#{n}@example.com"
  end

  # Create a basic user.
  factory :user do
    password "BasicTester1"
    password_confirmation "BasicTester1"
    confirmed_at { 1.day.ago }
    email
  end

  # Create a basic user profile.
  factory :user_profile, :aliases => [:admin_profile] do
    first_name
    last_name
    after_build { |user_profile| user_profile.user = Factory.build(:user) }
  end

  # Create a basic community.
  factory :community do
    name
    slogan "Default Community Slogan"
    label "Guild"
    admin_profile
  end

end
