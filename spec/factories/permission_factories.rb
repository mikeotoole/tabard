FactoryGirl.define do
  factory :permission do
    role
    permission_level "View"
    subject_class "Comment"
    
    trait :view do
      permission_level "View"
    end
    
    trait :update do
      permission_level "Update"
    end
    
    trait :create do
      permission_level "Create"
    end
    
    trait :delete do
      permission_level "Delete"
    end
    
    trait :comment do
      subject_class "Comment"
    end
  end
end