require 'spec_helper'

describe Page do
  it 'can be created by an author' do
    create_author_and_sign_in
    click_link 'table of contents'
    page.should have_content 'New page'
    visit new_page_path
    page.should have_content 'New page'
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    click_link 'table of contents'
    page.should_not have_content 'New page'
    visit new_page_path
    page.should_not have_content 'New page'
  end

  it 'can be edited by an author' do
    create_author_and_sign_in
    test_page = FactoryGirl.create :page
    click_link 'table of contents'
    click_link test_page.title
    click_link "Edit #{test_page.title}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    test_page = FactoryGirl.create :page
    click_link 'table of contents'
    click_link test_page.title
    page.should_not have_content 'Edit page'
    visit edit_page_path test_page
    page.should_not have_content 'Edit'
  end
end
