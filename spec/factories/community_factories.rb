FactoryGirl.define do
  # Create a basic community.
  factory :community do
    sequence(:name) {|n| "Community #{n}"}
    slogan "Default Community Slogan"
    label "Guild"
  end
end