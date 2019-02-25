require 'rails_helper'

feature 'select best answer', %q{
  To improve answer quality, author of question can select one answer as best.
} do
  
  given!(:question) { create(:question, :with_answers) }
  
  context 'author' do
    given(:user) { question.user }
    
    before do 
      sign_in user
      visit question_path(question)
      within("#answer-#{question.answers[-1].id}") { click_link('set best') }
    end
    
    scenario 'it selects one of answers as best', js: true do
      within("#answer-#{question.answers[-1].id}") { expect(page).to have_content('BEST') }
    end
    
    scenario 'changes his decision about best answer', js: true do
      within("#answer-#{question.answers[-1].id}") { expect(page).to have_content('BEST') }
      
      within("#answer-#{question.answers[-2].id}") do
        click_link('set best')
        expect(page).to have_content('BEST')
      end
    end
  end
  
  context 'not author' do
    scenario 'non-author cannot see select as best button' do
      sign_in ( create(:user))
      visit question_path(question)
      
      expect(page).not_to have_link 'set best'
    end
    
    scenario 'unauthenticated user cannot see select as best button' do
      visit question_path(question)
      
      expect(page).not_to have_link 'set best'
    end
  end
end