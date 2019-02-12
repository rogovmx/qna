require 'rails_helper'

feature 'delete question', %q{
  only author can delete his question
} do
  
  let!(:question) { create(:question) }
  
  let(:delete_action) do
    visit question_path(question)
    click_on 'Delete question'
  end
  
  context 'logged in user' do
    scenario 'author deletes his question' do
      sign_in(question.user)
      delete_action  
      
      expect(page).not_to have_content(question.body)
      expect(page).to have_content 'Question deleted'
    end
    
    scenario 'only author can see delete button' do
      sign_in(create(:user))
      visit question_path(question)
      
      expect(page).not_to have_content 'Delete question'
    end
  end
  
  context 'not logged in user' do
    scenario 'not logged in user cannot see delete button' do
      visit question_path(create(:question))
      
      expect(page).not_to have_content 'Delete question'
    end
  end
end