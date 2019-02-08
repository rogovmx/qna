require 'rails_helper'

feature 'view questions', %q{
  One can view the question.
  No matter logged in or not.
} do
  given(:user) { create(:user) }


  describe 'Question without answers' do
    given(:question) { create(:question) }

    scenario 'logged in user views the question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
      expect(current_path).to eq question_path(question)
    end

    scenario 'not logged in user views the question' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
      expect(current_path).to eq question_path(question)
    end
  end

  describe 'Question with answers' do
    given(:question_with_answers) { create(:question, :with_answers) }

    scenario 'logged in user views the question' do
      sign_in(user)
      visit question_path(question_with_answers)
      
      expect(question_with_answers.answers.any?).to be_truthy
      expect(page).to have_content(question_with_answers.title)
      expect(page).to have_content(question_with_answers.body)
      
      
      expect(current_path).to eq question_path(question_with_answers)
      question_with_answers.answers.each do |answer|
        expect(page).to have_content(answer.body)
      end
    end

    scenario 'not logged in user views the question' do
      visit question_path(question_with_answers)

      expect(question_with_answers.answers.any?).to be_truthy
      expect(page).to have_content(question_with_answers.title)
      expect(page).to have_content(question_with_answers.body)
      expect(current_path).to eq question_path(question_with_answers)
      question_with_answers.answers.each { |answer| expect(page).to have_content(answer.body) }
    end
  end
end
