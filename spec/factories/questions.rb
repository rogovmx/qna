FactoryBot.define do
  sequence(:title) {|i| "Title number: #{i}"}
  
  factory :question do
    title
    body "MyText"
    
    trait :invalid do
      title nil
      body nil   
    end
  end
end
