require 'spec_helper'

describe Lesson do
  context 'creating' do
    it 'lets the author view the New page' do
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
      visit table_of_contents_path
      page.should have_content 'New lesson'
      visit new_lesson_path
      page.should have_content 'New lesson'
    end

    it 'does not let students view the New page' do
      student = FactoryGirl.create :student
      login_as(student, :scope => :user)
      visit table_of_contents_path
      page.should_not have_content 'New lesson'
      visit new_lesson_path
      page.should_not have_content 'New lesson'
    end

    it 'lets authors create a lesson' do
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
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
      student = FactoryGirl.create :student
      section = lesson.sections.first
      login_as(student, :scope => :user)
      visit table_of_contents_path
      click_link section.name
      click_link lesson.name
      page.should have_content lesson.content
    end
  end

  context 'editing' do
    it 'can be edited by an author' do
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
      lesson = FactoryGirl.create :lesson
      section = lesson.sections.first
      visit section_lesson_path(section, lesson)
      click_link "Edit #{lesson.name}"
      page.should have_content 'Edit'
    end

    it 'cannot be edited by a student' do
      student = FactoryGirl.create :student
      login_as(student, :scope => :user)
      lesson = FactoryGirl.create :lesson
      section = lesson.sections.first
      visit section_lesson_path(section, lesson)
      page.should_not have_content 'Edit lesson'
      visit edit_section_lesson_path(section, lesson)
      page.should_not have_content 'Edit'
    end
  end

  context 'when it is not public' do
    it 'is visible to an author' do
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
      lesson = FactoryGirl.create :lesson, :public => false
      section = lesson.sections.first
      visit section_lesson_path(section, lesson)
      page.should have_content lesson.content
    end

    it 'is not visible to a student' do
      student = FactoryGirl.create :student
      login_as(student, :scope => :user)
      private_lesson = FactoryGirl.create :lesson, :public => false
      public_lesson = FactoryGirl.create :lesson
      section = private_lesson.sections.first
      visit section_lesson_path(section, private_lesson)
      page.should_not have_content private_lesson.content
    end
  end

  context 'deleting and restoring' do
    it 'is removed from the table of contents when it is deleted' do
      lesson = FactoryGirl.create :lesson
      section = lesson.sections.first
      lesson.destroy
      visit table_of_contents_path
      click_link section.name
      page.should_not have_content lesson.name
    end

    it 'is listed on the deleted lessons page for an author' do
      lesson = FactoryGirl.create :lesson
      section = lesson.sections.first
      lesson.destroy
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
      visit section_lessons_path(section) + "?deleted=true"
      page.should have_content lesson.name
    end

    it 'is not visible to a student' do
      lesson = FactoryGirl.create :lesson
      section = lesson.sections.first
      lesson.destroy
      student = FactoryGirl.create :student
      login_as(student, :scope => :user)
      visit section_lessons_path(section) + "?deleted=true"
      click_link lesson.name
      page.should_not have_content lesson.content
    end

    it 'can be restored' do
      lesson = FactoryGirl.create :lesson
      section = lesson.sections.first
      lesson.destroy
      author = FactoryGirl.create :author
      login_as(author, :scope => :user)
      visit section_lesson_path(section, lesson) + "?deleted=true"
      click_button 'Restore'
      visit table_of_contents_path
      click_link section.name
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
