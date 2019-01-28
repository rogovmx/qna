require 'rails_helper'

feature 'user sign in', %q{
  In order to be able to ask question
  As an unauthenticated user
  I want to be able to sign in } do

  given(:user) { create(:user) }
  
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do 
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registred user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end

feature 'user sign up', %q{
  In order to be able to ask question
  As an non-registred user
  I want to be able to sign up } do
  
  scenario 'Non-registred user tries to sign up' do
    visit new_user_registration_path
    within 'form#new_user' do
      fill_in 'Email', with: 'new@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'user[password_confirmation]', with: '123456'
      click_on 'Sign up'
    end
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end

feature 'User log out', %q{ In order to able end session user can be able to log-out } do
  given(:user) { create(:user) }

  scenario 'Logged-in user clicks logout button' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
