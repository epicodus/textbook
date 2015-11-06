require 'spec_helper'

describe 'when a visitor goes to the homepage' do
  context 'the page they see if no pages have been created' do
    it 'has "Welcome to your new site" as the title' do
      visit '/'
      expect(page).to have_content "Welcome to your new site"
    end
  end

  context 'the page they see if a page has been created' do
    it 'is the first page of the first section' do
      test_page = FactoryGirl.create :lesson
      visit '/'
      expect(page).to have_content test_page.name
    end
  end
end
