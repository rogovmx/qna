FactoryBot.define do
  sequence(:title) {|i| "Title number: #{i}"}
  
  factory :question do
    user
    title
    body "MyText"
    
    trait :invalid do
      title nil
      body nil   
    end
  end
  
  factory :question_with_answers, class: Question do
    user
    title
    body "MyText"
    after(:create) do |question|
      create_list(:answer, 5, question: question)
    end
  end    
end
