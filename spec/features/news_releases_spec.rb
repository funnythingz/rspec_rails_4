require 'rspec'

feature 'News releases' do
  # ユーザーとして
  context 'as a user' do
    # ニュースリリースを追加する
    scenario 'adds a news release' do
      user = create(:user)
      sign_in(user)
      visit root_path
      click_link 'News'

      expect(page).to_not have_content 'BigCo switches to Rails'
      click_link 'Add News Release'

      fill_in 'Date', with: '2014-10-13'
      fill_in 'Title', with: 'BigCo switches to Rails'
      fill_in 'Body', with: 'BigCo has released a new website built with open source.'
      click_button 'Create News release'

      expect(current_path).to eq news_releases_path
      expect(page).to have_content 'Successfully created news release.'
      expect(page).to have_content '2014-10-13: BigCo switches to Rails'
    end
  end

  # ゲストとして
  context 'as a quest' do
    # ニュースリリースを読む
    scenario 'reads a news release'
  end
end