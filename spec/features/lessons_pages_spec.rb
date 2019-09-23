require 'spec_helper'

describe Lesson do
  context 'creating' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }
    let!(:lesson) { FactoryBot.build :lesson, section: section }

    before { login_as(author, scope: :user) }

    it 'lets the author view the New page' do
      visit new_lesson_path
      expect(page).to have_content 'New Lesson'
    end

    it 'does not let students view the New page' do
      login_as(student, scope: :user)
      visit courses_path
      expect(page).to_not have_content 'New Lesson'
      visit new_lesson_path
      expect(page).to_not have_content 'New Lesson'
    end

    it 'lets authors create a lesson' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      select section.name, from: 'Sections'
      click_button 'Save'
      expect(page).to have_content 'Lesson saved'
    end

    it 'displays errors if you try to save an invalid lesson' do
      login_as(author, scope: :user)
      visit new_lesson_path
      fill_in 'Name', with: ''
      click_button 'Save'
      expect(page).to have_content "Please correct these problems:"
    end

    it 'can have a video embedded in it' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      fill_in 'Video ID', with: lesson.video_id
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to have_content 'Lesson saved'
    end

    it "doesn't have to have video embedded in it" do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page.html).to_not match /<div id="video">/
    end

    it 'can have a cheat sheet' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      fill_in 'Video ID', with: lesson.video_id
      fill_in 'Cheat sheet (use Markdown)', with: lesson.cheat_sheet
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to have_content 'Lesson saved'
    end

    it "doesn't have to have a cheat sheet" do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to_not have_content 'Cheat sheet'
    end

    it 'can have an update warning' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      fill_in 'Update warning (use Markdown)', with: lesson.update_warning
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to have_content 'Lesson saved'
    end

    it "doesn't have to have an update warning" do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page.html).to_not match /alert-danger/
    end

    it 'can have a teacher notes section' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      fill_in 'Teacher notes (use Markdown)', with: lesson.teacher_notes
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to have_content 'Lesson saved'
    end

    it "doesn't have to have a teacher notes section" do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page.html).to_not match /alert-danger/
    end

    it 'uses markdown to format lessons' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: '*This* is Markdown.'
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to have_content 'Lesson saved'
    end
  end

  context 'viewing' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }
    let!(:lesson) { FactoryBot.create :lesson, section: section }

    it 'can be viewed by a student' do
      login_as(student, scope: :user)
      visit course_path(section.course)
      click_link section.name
      click_link lesson.name
      expect(page).to have_content lesson.content
    end

    it "shows teacher notes section to teachers" do
      login_as(author, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_content lesson.teacher_notes
    end

    it "doesn't show teacher notes section to students" do
      login_as(student, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page.html).to_not match lesson.teacher_notes
    end

    it "redirects if lesson not found" do
      login_as(student, scope: :user)
      lesson.really_destroy!
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_content 'Page not found'
    end
  end

  context 'editing' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }
    let!(:lesson) { FactoryBot.create :lesson, section: section }

    before { login_as(author, scope: :user) }

    it 'can be edited by an author' do
      visit course_section_lesson_path(section.course, section, lesson)
      click_link "Edit"
      fill_in 'Name', with: 'Updated lesson'
      click_button 'Save'
      expect(page).to have_content 'Lesson updated'
    end

    it "displays errors if you try to save an invalid lesson when editing" do
      visit edit_lesson_path(lesson)
      fill_in 'Name', with: ''
      click_button 'Save'
      expect(page).to have_content "Please correct these problems:"
    end

    it 'cannot be edited by a student' do
      login_as(student, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to_not have_content 'Edit lesson'
      visit edit_lesson_path(lesson)
      expect(page).to_not have_content 'Edit'
    end
  end

  context 'when it is not public' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }

    before { login_as(author, scope: :user) }

    it 'is visible to an author' do
      lesson = FactoryBot.create :lesson, section: section, public: false
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_content lesson.content
    end

    it 'is not visible to a student' do
      login_as(student, scope: :user)
      private_lesson = FactoryBot.create :lesson, section: section, public: false
      public_lesson = FactoryBot.create :lesson, section: section
      visit course_section_lesson_path(section.course, section, private_lesson)
      expect(page).to have_content "Sorry, that lesson isn't finished yet."
    end

    it 'is not visible on the course show page' do
      login_as(student, scope: :user)
      private_lesson = FactoryBot.create :lesson, section: section, public: false
      public_lesson = FactoryBot.create :lesson, section: section
      visit course_path(section.course)
      expect(page).to_not have_content private_lesson.content
    end

    it 'is not visible on the section show page' do
      login_as(student, scope: :user)
      private_lesson = FactoryBot.create :lesson, section: section, public: false
      public_lesson = FactoryBot.create :lesson, section: section
      visit course_section_path(section.course, section)
      expect(page).to_not have_content private_lesson.content
    end
  end

  context 'deleting and restoring' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }
    let!(:lesson) { FactoryBot.create :lesson, section: section }

    before { login_as(author, scope: :user) }

    it 'is removed from the courses page when it is deleted' do
      lesson.destroy
      visit course_path(section.course)
      click_link section.name
      expect(page).to have_content 'Removed Lessons:'
      expect(page).to have_content lesson.name
    end

    it 'is listed on the deleted lessons page for an author' do
      lesson.destroy
      visit course_section_lessons_path(section.course, section) + "?deleted=true"
      expect(page).to have_content lesson.name
    end

    it 'can be deleted' do
      visit course_section_lesson_path(lesson.sections.first.course, lesson.sections.first, lesson)
      click_link 'Delete'
      expect(page).to have_content 'Lesson deleted.'
    end

    it 'is not visible to a student' do
      lesson.destroy
      login_as(student, scope: :user)
      visit course_section_lessons_path(section.course, section) + "?deleted=true"
      click_link lesson.name
      expect(page).to have_content "Sorry, that lesson isn't finished yet."
    end

    it 'can be restored' do
      lesson.destroy
      visit courses_path
      click_link 'View Deleted Lessons'
      click_link lesson.name
      click_button 'Restore'
      expect(page).to have_content 'Lesson restored'
    end
  end

  context 'searching' do
    let!(:lesson) { FactoryBot.create :lesson }

    it 'lets you search for lessons' do
      visit courses_path
      fill_in 'Search lessons', with: lesson.content.split.last
      click_on 'lesson-search'
      expect(page).to have_content lesson.name
    end
  end

  context 'redirecting' do
    it 'redirects from lessons index to courses index when there are no params' do
      visit lessons_path
      expect(page.current_path).to eq courses_path
    end
  end
end
