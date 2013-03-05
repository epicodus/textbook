require 'spec_helper'

describe Section do
  it 'can be created by an author' do
    create_author_and_sign_in
    visit chapters_path
    page.should have_content 'New section'
    visit new_section_path
    page.should have_content 'New'
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    visit chapters_path
    page.should_not have_content 'New section'
    visit new_section_path
    page.should_not have_content 'New'
  end

  it 'can be edited by an author' do
    create_author_and_sign_in
    section = FactoryGirl.create :section
    visit chapters_path
    click_link "edit_section_#{section.id}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    section = FactoryGirl.create :section
    visit chapters_path
    page.should_not have_content 'edit'
    visit edit_section_path section
    page.should_not have_content 'Edit'
  end
end
