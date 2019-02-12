FactoryBot.define do
  sequence(:body) {|i| "Test answer body number #{i}"}
  
  factory :answer do
    user
    question
    body
    
    trait :invalid do
      body nil   
    end
  end
end
