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
    visit lesson_path lesson
    click_link "Edit #{lesson.name}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    create_student_and_sign_in
    lesson = FactoryGirl.create :lesson
    visit lesson_path lesson
    page.should_not have_content 'Edit lesson'
    visit edit_lesson_path lesson
    page.should_not have_content 'Edit'
  end

  context 'when it is not public' do
    it 'is visible to an author' do
      create_author_and_sign_in
      lesson = FactoryGirl.create :lesson, :public => false
      visit lesson_path lesson
      page.should have_content lesson.name
    end

    it 'is visible to a student who is paid' do
      create_paid_student_and_sign_in
      lesson = FactoryGirl.create :lesson, :public => false
      visit lesson_path lesson
      page.should have_content lesson.name
    end

    context 'for a student who is not paid' do
      it 'is not visible' do
        create_student_and_sign_in
        private_lesson = FactoryGirl.create :lesson, :public => false
        public_lesson = FactoryGirl.create :lesson
        visit lesson_path private_lesson
        page.should_not have_content private_lesson.name
      end
    end
  end
end
