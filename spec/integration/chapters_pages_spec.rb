require 'spec_helper'

describe Chapter do
  it 'can be created by an author' do
    create_author_and_sign_in
    visit chapters_path
    page.should have_content 'New chapter'
    visit new_chapter_path
    page.should have_content 'New'
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    visit chapters_path
    page.should_not have_content 'New chapter'
    visit new_chapter_path
    page.should_not have_content 'New'
  end

  it 'can be edited by an author' do
    create_author_and_sign_in
    chapter = FactoryGirl.create :chapter
    visit chapters_path
    click_link chapter.name
    click_link "Edit #{chapter.name}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    chapter = FactoryGirl.create :chapter
    visit chapters_path
    click_link chapter.name
    page.should_not have_content 'Edit'
    visit edit_chapter_path chapter
    page.should_not have_content 'Edit'
  end
end
