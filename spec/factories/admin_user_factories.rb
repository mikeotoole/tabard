FactoryGirl.define do
  # Create a superadmin user.
  factory :admin_user do
    password "Password"
    password_confirmation "Password"
    sequence(:email) {|n| "person#{n}@example.com"}
    role "superadmin"
  end
end