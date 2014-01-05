require 'spec_helper'

describe Lesson do
  context 'creating' do
    it 'lets the author view the New page' do
      create_author_and_sign_in
      visit table_of_contents_path
      page.should have_content 'New lesson'
      visit new_lesson_path
      page.should have_content 'New lesson'
    end

    it 'does not let students view the New page' do
      create_student_and_sign_in
      visit table_of_contents_path
      page.should_not have_content 'New lesson'
      visit new_lesson_path
      page.should_not have_content 'New lesson'
    end

    it 'lets authors create a lesson' do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.should have_content lesson.content
    end

    it 'can have a video embedded in it' do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      fill_in 'Video ID', :with => lesson.video_id
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.html.should =~ /12345/
    end

    it "doesn't have to have video embedded in it" do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.html.should_not =~ /<div id="video">/
    end

    it 'can have a cheat sheet' do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      fill_in 'Video ID', :with => lesson.video_id
      fill_in 'Cheat sheet (use Markdown)', :with => lesson.cheat_sheet
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.should have_content lesson.cheat_sheet
    end

    it "doesn't have to have a cheat sheet" do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.should_not have_content 'Cheat sheet'
    end

    it 'can have an update warning' do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      fill_in 'Update warning (use Markdown)', :with => lesson.update_warning
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.should have_content lesson.update_warning
    end

    it "doesn't have to have an update warning" do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => lesson.content
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.html.should_not =~ /alert-danger/
    end

    it 'uses markdown to format lessons' do
      create_author_and_sign_in
      lesson = FactoryGirl.build :lesson
      visit new_lesson_path
      fill_in 'Name', :with => lesson.name
      fill_in 'Lesson number', :with => lesson.number
      fill_in 'Content (use Markdown)', :with => '*This* is Markdown.'
      select lesson.section.name, :from => 'Section'
      click_button 'Save'
      page.html.should =~ /<p><em>This<\/em> is Markdown.<\/p>/
    end
  end

  context 'viewing' do
    it 'can be viewed by a student' do
      lesson = FactoryGirl.create :lesson
      create_student_and_sign_in
      visit table_of_contents_path
      click_link lesson.section.name
      click_link lesson.name
      page.should have_content lesson.content
    end
  end

  context 'editing' do
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
  end

  context 'when it is not public' do
    it 'is visible to an author' do
      create_author_and_sign_in
      lesson = FactoryGirl.create :lesson, :public => false
      visit lesson_path lesson
      page.should have_content lesson.content
    end

    it 'is not visible to a student' do
      create_student_and_sign_in
      private_lesson = FactoryGirl.create :lesson, :public => false
      public_lesson = FactoryGirl.create :lesson
      visit lesson_path private_lesson
      page.should_not have_content private_lesson.content
    end
  end

  context 'deleting and restoring' do
    it 'is removed from the table of contents when it is deleted' do
      lesson = FactoryGirl.create :lesson
      lesson.destroy
      visit table_of_contents_path
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
      visit table_of_contents_path
      click_link lesson.section.name
      page.should have_content lesson.name
    end
  end

  context 'searching' do
    it 'lets you search for lessons' do
      lesson = FactoryGirl.create :lesson
      visit table_of_contents_path
      fill_in 'Search for:', :with => lesson.content.split.last
      click_button 'Search'
      page.should have_content lesson.name
    end
  end
end
