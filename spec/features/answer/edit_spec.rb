require 'rails_helper'

feature 'User can edit own answer', %q{
  In ordert to correct mistakes
  Is an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user cant edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'
        expect(page).not_to have_content(answer.body)
        expect(page).to have_content 'edited answer'

#        save_and_open_page
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'only author sees edit button' do
      sign_in(create(:user))
      visit question_path(answer.question)
      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits his answer with error', js: true do
      sign_in user
      visit question_path(question)
      
      click_on 'Edit'
      
      within '.answers' do
        fill_in 'answer[body]', with: 'er'
        click_on 'Save'
        expect(page).to have_content(answer.body)
      end
      expect(page).to have_content 'Body is too short (minimum is 3 characters)'
    end
  end
end