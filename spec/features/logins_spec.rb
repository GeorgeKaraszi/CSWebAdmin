require 'rails_helper'

RSpec.feature "Logins", type: :feature do

  scenario 'User is redirected to login page' do
    visit root_path

    expect(current_path).to eql(new_user_session_path)
    expect(page).to have_content('Login')
    expect(page).to have_content('Password')
  end

  scenario 'Allow user to sign in as admin' do
    visit '/login'

    fill_in 'user[login]', with: 'admin'
    fill_in 'user[password]', with: 'test'
    click_button('Log in')

    expect(page).to have_content('Users ')
    expect(page).to have_content('Groups ')
    expect(page).to have_content('Manage Users')
    expect(page).to have_content('Manage Groups')
    expect(page).to have_content('Log out')

    expect(current_path).to eql(root_path)
  end
end
