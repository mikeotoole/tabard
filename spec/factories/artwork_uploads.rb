# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :artwork_upload do
    email "robobilly@digitalaugment.com"
    owner_name "Robo Billy"
    artwork_description "MyString"
    street "MyString"
    city "MyString"
    zipcode "MyString"
    country "MyString"
    attribution_name "MyString"
    attribution_url "MyString"
    artwork_image { File.open("#{Rails.root}/spec/testing_files/goodAvatar1.jpg") }
    document_id { FactoryGirl.create(:artwork_agreement).id }
    accepted_current_artwork_agreement "1"
    certify_owner_of_artwork true

    factory :artwork_upload_att do
      remote_artwork_image_url "http://tabard.com/images/tabard-logo.png" # TOOD Mike, This will need to be updated when the site is launched.
    end
  end
end
