# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission_default do
    role_id 1
    object_class "MyString"
    can_read false
    can_update false
    can_create false
    can_destroy false
    can_lock false
    can_accept false
    can_read_nested false
    can_update_nested false
    can_create_nested false
    can_destroy_nested false
    can_lock_nested false
    can_accept_nested false
  end
end
