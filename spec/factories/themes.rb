# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :theme do
    community_id 1
    background_image "MyString"
    predefined_theme "MyString"
  end
end
