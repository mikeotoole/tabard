# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :theme do
  	sequence(:name) {|n| "HERP Theme #{n}"}
	css "theme"
	background_author "person"
	background_author_url "url"
	thumbnail  "thumbnail"
  end
end
