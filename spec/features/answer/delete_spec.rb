require 'rails_helper'

feature 'delete answer', %q{
  only author can delete his answer
} do
    
  let(:delete_action) { click_on('Delete answer', match: :first) } 
  
  given(:answer) { create(:answer) }
  
  context 'logged in user' do
    scenario 'author deletes his answer' do
      sign_in(answer.user)
      visit question_path(answer.question)
      delete_action
      
      expect(page).not_to have_content(answer.body)
    end
    
    scenario 'only author sees delete button' do
      sign_in(create(:user))
      visit question_path(answer.question)
      
      expect(page).to_not have_link 'Delete answer'
    end
  end
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see delete button' do
      visit question_path(answer.question)
      
      expect(page).not_to have_link 'Delete answer'
    end
  end
  
end
