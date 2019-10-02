require 'rails_helper'

RSpec.feature "UserBrowsesEmails", type: :feature do
  scenario 'and sees their emails' do
    visit emails_path
    expect(page).to have_content("Emails")
    expect(page).to have_css(".openSelectedLinks", :count => 10)
  end

  scenario 'and clicks show on an email' do
    visit emails_path
    puts page.html
    link = page.find_link('59')[:href]
    puts link
  end
end
