FactoryGirl.define do 
  # Create a basic user profile.
  factory :user_profile do
    sequence(:first_name) {|n| "First Name #{n}"}
    sequence(:last_name) {|n| "Last Name #{n}"}
    user
  end
  
  # Create a user profile with a user, 3 wow characters and 3 swtor characters.
  factory :user_profile_with_characters, :parent => :user_profile do
    after_create do |profile|
      3.times do
        FactoryGirl.create(:character_proxy_with_wow_character, :user_profile => profile)
        FactoryGirl.create(:character_proxy_with_swtor_character, :user_profile => profile)
      end  
    end
  end
end  