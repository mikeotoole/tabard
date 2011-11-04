FactoryGirl.define do
  # Create a superadmin user.
  factory :admin_user do
    password "BasicTester1"
    password_confirmation "BasicTester1"
    sequence(:email) {|n| "person#{n}@example.com"}
    role "superadmin"
  end
end