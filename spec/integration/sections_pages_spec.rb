require 'spec_helper'

describe Section do
  it 'can be created by an author' do
    create_author_and_sign_in
    click_link 'table of contents'
    page.should have_content 'New section'
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    click_link 'table of contents'
    page.should_not have_content 'New section'
    visit new_section_path
    page.should_not have_content 'New'
  end

  it 'can be deleted by an author' do
    create_author_and_sign_in
    FactoryGirl.create :section
    click_link 'table of contents'
    page.should have_content 'Delete'
  end

  it 'cannot be deleted by a student' do
    create_student_and_sign_in
    FactoryGirl.create :section
    click_link 'table of contents'
    page.should_not have_content 'Delete'
  end

  it 'can be viewed by an author' do
    create_author_and_sign_in
    section = FactoryGirl.create :section
    click_link 'table of contents'
    click_link section.name
    page.should have_selector "h1", :content => section.name
  end

  it 'can be viewed by a student' do
    create_student_and_sign_in
    section = FactoryGirl.create :section
    click_link 'table of contents'
    click_link section.name
    page.should have_selector "h1", :content => section.name
  end

  it 'can be edited by an author' do
    create_author_and_sign_in
    section = FactoryGirl.create :section
    click_link 'table of contents'
    click_link section.name
    click_link "Edit #{section.name}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    section = FactoryGirl.create :section
    click_link 'table of contents'
    click_link section.name
    page.should_not have_content 'Edit'
    visit edit_section_path section
    page.should_not have_content 'Edit'
  end
end
