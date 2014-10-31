require 'spec_helper'

describe Section, :js => true do
  it 'can be created by an author' do
    create_author_and_sign_in
    chapter = FactoryGirl.create :chapter
    visit table_of_contents_path
    click_link 'New section'
    fill_in 'Name', :with => 'Awesome section'
    fill_in 'Section number', :with => '1'
    click_button 'Create Section'
    page.should have_content 'Awesome section'
  end

  it 'displays errors if you try to save an invalid section' do
    create_author_and_sign_in
    visit table_of_contents_path
    click_link 'New section'
    click_button 'Create Section'
    page.should have_content "Please correct these problems:"
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    visit table_of_contents_path
    page.should_not have_content 'New section'
    visit new_section_path
    page.should_not have_content 'New'
  end

  it 'can be edited by an author' do
    create_author_and_sign_in
    section = FactoryGirl.create :section
    visit table_of_contents_path
    click_link "edit_section_#{section.id}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    section = FactoryGirl.create :section
    visit table_of_contents_path
    page.should_not have_content 'edit'
    visit edit_section_path section
    page.should_not have_content 'Edit'
  end

  it 'can be deleted by an author' do
    create_author_and_sign_in
    section = FactoryGirl.create :section
    visit table_of_contents_path
    click_link "delete_section_#{section.id}"
    page.should_not have_content section.name
  end

  it 'cannot be deleted by a student' do
    create_student_and_sign_in
    section = FactoryGirl.create :section
    visit table_of_contents_path
    page.should_not have_content 'delete'
  end
end
