FactoryBot.define do
  sequence(:title) {|i| "Question Title number: #{i}"}
  
  factory :question do
    user
    title
    body "MyText"
    
    trait :invalid do
      title nil
      body nil   
    end
    
    trait :with_answers do
      after(:create) do |question|
        create_list(:answer, 5, question: question)
      end     
    end
  end   
end
