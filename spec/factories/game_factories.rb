FactoryGirl.define do
  factory :swtor do
    sequence(:name) {|n| "SWTOR Game #{n}" }
    
    trait :inactive do
      is_active false
    end
    
    factory :inactive_swtor, :traits => [:inactive]
  end
  
  factory :wow do
    sequence(:name) {|n| "WOW Game #{n}" }
        
    trait :inactive do
      is_active false
    end
    
    factory :inactive_wow, :traits => [:inactive]
  end
end