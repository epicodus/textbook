require 'spec_helper'

describe Lesson do
  it 'can be created by an author' do
    create_author_and_sign_in
    visit chapters_path
    page.should have_content 'New lesson'
    visit new_lesson_path
    page.should have_content 'New lesson'
  end

  it 'cannot be created by a student' do
    create_student_and_sign_in
    visit chapters_path
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
      page.should have_content lesson.content
    end

    it 'is visible to a student who is paid' do
      create_paid_student_and_sign_in
      lesson = FactoryGirl.create :lesson, :public => false
      visit lesson_path lesson
      page.should have_content lesson.content
    end

    context 'for a student who is not paid' do
      it 'is not visible' do
        create_student_and_sign_in
        private_lesson = FactoryGirl.create :lesson, :public => false
        public_lesson = FactoryGirl.create :lesson
        visit lesson_path private_lesson
        page.should_not have_content private_lesson.content
      end
    end
  end

  context 'deleting and restoring' do
    it 'is removed from the table of contents when it is deleted' do
      lesson = FactoryGirl.create :lesson
      lesson.destroy
      visit chapters_path
      click_link lesson.section.chapter.name
      click_link lesson.section.name
      page.should_not have_content lesson.name
    end

    it 'is listed on the deleted lessons page for an author' do
      lesson = FactoryGirl.create :lesson
      lesson.destroy
      create_author_and_sign_in
      visit lessons_path + "?deleted=true"
      page.should have_content lesson.name
    end

    it 'is not visible to a student' do
      lesson = FactoryGirl.create :lesson
      lesson.destroy
      create_student_and_sign_in
      visit lessons_path + "?deleted=true"
      click_link lesson.name
      page.should_not have_content lesson.content
    end

    it 'can be restored' do
      lesson = FactoryGirl.create :lesson
      lesson.destroy
      create_author_and_sign_in
      visit lesson_path(lesson) + "?deleted=true"
      click_button 'Restore'
      visit chapters_path
      page.should have_content lesson.name
    end
  end
end
