require 'rails_helper'

feature 'list questions', %q{
  One can view list of questions. 
  No matter logged in or not.
} do
  given(:user) { create(:user) }
  
  before { @questions = create_list(:question, 3) }
  
  scenario 'logged in user view list of questions' do
    sign_in(user)
    visit questions_path

    @questions.each { |question| expect(page).to have_content(question.title) }
  end
  
  scenario 'not logged in user (guest) view list of questions' do
    visit questions_path
    
    @questions.each { |question| expect(page).to have_content(question.title)}
  end
end
