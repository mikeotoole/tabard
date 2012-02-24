# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :artwork_upload do
    email "robobilly@digitalaugment.com"
    attribution_name "MyString"
    attribution_url "MyString"
    artwork_image { File.open("#{Rails.root}/spec/testing_files/goodAvatar1.jpg") }
    association :document, :factory => :artwork_agreement
    accepted_current_artwork_agreement "1"
  end
  
  factory :artwork_upload_att, :class => :artwork_upload do
    email "robobilly@digitalaugment.com"
    remote_artwork_image_url "http://interfacelift.com/wallpaper/D29fc15f/02855_paradisefound_320x480.jpg"
    document_id 1
    accepted_current_artwork_agreement "1"
  end
end
