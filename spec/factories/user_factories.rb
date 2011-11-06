FactoryGirl.define do
  # Create a basic user.
  factory :user do
    password "Password"
    password_confirmation "Password"
    confirmed_at { 1.day.ago }
    sequence(:email) {|n| "person#{n}@example.com"}
  end

  # Create an active user with full associations.
  factory :billy, :class => User do
    password "Password"
    password_confirmation "Password"
    confirmed_at { 1.day.ago }
    email "billy@robo.com"
    after_create do |u|
      FactoryGirl.create( :user_profile_with_characters,
                          :user => u,
                          :first_name => "Robo",
                          :last_name => "Billy")
    end
  end

  factory :community_admin, :parent => :user do
    after_create do |u|
      FactoryGirl.create(:user_profile, :user => u)
      FactoryGirl.create(:community, :admin_profile => u.user_profile)
    end
  end
end
