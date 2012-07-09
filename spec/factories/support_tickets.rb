# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :support_ticket do
    user_profile
    admin_user
    status SupportTicket::DEFAULT_STATUS
    body "MyText"
  end
end
