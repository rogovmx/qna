require 'rails_helper'

feature 'Create answer', %q{
  User can create answer while in question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates the answer', js: true do
      fill_in 'answer[body]', with: 'My test answer'
      click_on 'Post your answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'My test answer'
      end
    end

    scenario 'creates the invalid answer', js: true do
      fill_in 'answer[body]', with: 'My'
      click_on 'Post your answer'

      expect(page).to have_content 'Body is too short'
    end

    scenario 'creates answer with attached files', js: true do
      fill_in 'answer[body]', with: 'My test answer'
      attach_file 'answer[files][]', ["#{Rails.root}/public/404.html", "#{Rails.root}/public/422.html"]
      click_on 'Post your answer'

      expect(page).to have_link '404.html'
      expect(page).to have_link '422.html'
    end

  end

  scenario 'unauthenticated user tries to create the answer', js: true do
    visit question_path(question)
    fill_in 'answer[body]', with: 'My test answer'
    click_on 'Post your answer'

    expect(page).to_not have_content 'My test answer'
  end
end

