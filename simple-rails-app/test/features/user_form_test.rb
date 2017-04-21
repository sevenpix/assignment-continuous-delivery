require 'test_helper'

class UserFormTest < Capybara::Rails::TestCase
  test 'user#user is valid and gets saved' do
    visit new_user_path
    within('#new_user') do
      fill_in('Name', with: 'Donald')
      fill_in('Last name', with: 'Duck')
      fill_in('Age', with: '32')
      fill_in('Email', with: 'donald.duck@entenhausen.de')
    end
    click_button('Create User')

    assert_content page, 'User was successfully created.'
  end
end
