# This file seeds our first ToS and PP

##### SEED TOS #####
puts "Creating Terms of Service"
TermsOfService.create!(
  body: File.read(File.join(Rails.root, "db/assets/terms_of_service_v1.txt")), 
  version: "1", 
  is_published: true)

###### SEED PP #####
puts "Creating Privacy Policy"
PrivacyPolicy.create!(
  body: File.read(File.join(Rails.root, "db/assets/privacy_policy_v1.txt")), 
  version: "1", 
  is_published: true)
