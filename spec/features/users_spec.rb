require 'spec_helper'

feature 'User management' do
  # 新しいユーザーを追加する
  scenario 'adds a new user', js: true do
    sign_in(create(:admin))
    visit root_path

    expect{
      click_link 'Users'
      click_link 'New User'
      fill_in 'Email', with: 'newuser@example.com'
      find('#password').fill_in 'Password', with: 'secret123'
      find('#password_confirmation').fill_in 'Password confirmation', with: 'secret123'
      click_button 'Create User'
    }.to change(User, :count).by(1)

    # NOTE: 必要に応じてブラウザでページの確認を行える
    # save_and_open_page

    expect(current_path).to eq users_path
    expect(page).to have_content 'New user created'

    within 'h1' do
      expect(page).to have_content 'Users'
    end

    expect(page).to have_content 'newuser@example.com'
  end
end