require 'spec_helper'

describe Lesson do
  it 'can be created by an author' do
    create_author_and_sign_in
    visit sections_path
    page.should have_content 'New lesson'
    visit new_lesson_path
    page.should have_content 'New lesson'
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    visit sections_path
    page.should_not have_content 'New lesson'
    visit new_lesson_path
    page.should_not have_content 'New lesson'
  end

  it 'can be edited by an author' do
    create_author_and_sign_in
    lesson = FactoryGirl.create :lesson
    visit sections_path
    click_link lesson.name
    click_link "Edit #{lesson.name}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    lesson = FactoryGirl.create :lesson
    visit sections_path
    click_link lesson.name
    page.should_not have_content 'Edit lesson'
    visit edit_lesson_path lesson
    page.should_not have_content 'Edit'
  end
end
