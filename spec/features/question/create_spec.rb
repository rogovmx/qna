require 'rails_helper'

feature 'user can create question', %q{
  In order to get answer from community
  As an auth user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }
  
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'creates question' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'question text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully added'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'question text'
    end

    scenario 'creates the invalid question' do   
      fill_in 'question[title]', with: nil
      fill_in 'question[body]', with: nil
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end
  
  scenario 'Non-auth user tries to create question' do
    visit questions_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end