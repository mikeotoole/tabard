FactoryGirl.define do
  factory :role do
    sequence(:name) {|n| "Role Name #{n}" }
    community
  end
end
