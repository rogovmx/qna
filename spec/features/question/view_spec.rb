require 'rails_helper'

feature 'view question with answers', %q{
  One can view the question with answers.
  No matter logged in or not.
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }
  
  scenario 'logged in user views the question' do
    sign_in(user)
    visit question_path(question)
    
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(current_path).to eq question_path(question)
    question.answers.each do |answer| 
      expect(page).to have_content(answer.body)
    end

  end
  
  scenario 'not logged in user views the question' do
    visit question_path(question)
    
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(current_path).to eq question_path(question)
    question.answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
