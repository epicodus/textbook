require 'spec_helper'

describe Lesson do
  context 'creating' do
    let(:author) { FactoryGirl.create :author }
    let(:student) { FactoryGirl.create :student }
    let!(:section) { FactoryGirl.create :section }
    let!(:lesson) { FactoryGirl.build :lesson, section: section }

    before { login_as(author, scope: :user) }

    it 'lets the author view the New page' do
      visit table_of_contents_path
      expect(page).to have_content 'New lesson'
      visit new_lesson_path
      expect(page).to have_content 'New lesson'
    end

    it 'does not let students view the New page' do
      login_as(student, scope: :user)
      visit table_of_contents_path
      expect(page).to_not have_content 'New lesson'
      visit new_lesson_path
      expect(page).to_not have_content 'New lesson'
    end

    it 'lets authors create a lesson' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page).to have_content lesson.content
    end

    it 'can have a video embedded in it' do
      visit new_lesson_path
      fill_in 'Name', with: lesson.name
      fill_in 'Content (use Markdown)', with: lesson.content
      fill_in 'Video ID', with: lesson.video_id
      select section.name, from: 'Section'
      click_button 'Save'
      expect(page.html).to match /12345/
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
      expect(page).to have_content lesson.cheat_sheet
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
      expect(page).to have_content lesson.update_warning
    end

    it "doesn't have to have an update warning" do
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
      expect(page.html).to match /<p><em>This<\/em> is Markdown.<\/p>/
    end
  end

  context 'viewing' do
    let(:student) { FactoryGirl.create :student }
    let!(:section) { FactoryGirl.create :section }
    let!(:lesson) { FactoryGirl.create :lesson, section: section }

    it 'can be viewed by a student' do
      login_as(student, scope: :user)
      visit table_of_contents_path
      click_link section.name
      click_link lesson.name
      expect(page).to have_content lesson.content
    end
  end

  context 'editing' do
    let(:author) { FactoryGirl.create :author }
    let(:student) { FactoryGirl.create :student }
    let!(:section) { FactoryGirl.create :section }
    let!(:lesson) { FactoryGirl.create :lesson, section: section }

    before { login_as(author, scope: :user) }

    it 'can be edited by an author' do
      visit lesson_show_path(section, lesson)
      click_link "Edit #{lesson.name}"
      fill_in 'Name', with: 'Updated lesson'
      click_button 'Save'
      expect(page).to have_content 'Lesson updated'
    end

    it "doesn't update when name and/or number are blank" do
      visit lesson_show_path(section, lesson)
      click_link "Edit #{lesson.name}"
      fill_in 'Name', with: ''
      click_button 'Save'
      expect(page).to have_content "Edit #{lesson.name}"
    end

    it 'cannot be edited by a student' do
      login_as(student, scope: :user)
      visit lesson_show_path(section, lesson)
      expect(page).to_not have_content 'Edit lesson'
      visit edit_section_lesson_path(section, lesson)
      expect(page).to_not have_content 'Edit'
    end
  end

  context 'when it is not public' do
    let(:author) { FactoryGirl.create :author }
    let(:student) { FactoryGirl.create :student }
    let!(:section) { FactoryGirl.create :section }

    before { login_as(author, scope: :user) }

    it 'is visible to an author' do
      lesson = FactoryGirl.create :lesson, section: section, public: false
      visit lesson_show_path(section, lesson)
      expect(page).to have_content lesson.content
    end

    it 'is not visible to a student' do
      login_as(student, scope: :user)
      private_lesson = FactoryGirl.create :lesson, section: section, public: false
      public_lesson = FactoryGirl.create :lesson, section: section
      visit lesson_show_path(section, private_lesson)
      expect(page).to_not have_content private_lesson.content
    end
  end

  context 'deleting and restoring' do
    let(:author) { FactoryGirl.create :author }
    let(:student) { FactoryGirl.create :student }
    let!(:section) { FactoryGirl.create :section }
    let!(:lesson) { FactoryGirl.create :lesson, section: section }

    before { login_as(author, scope: :user) }

    it 'is removed from the table of contents when it is deleted' do
      lesson.destroy
      visit table_of_contents_path
      click_link section.name
      expect(page).to_not have_content lesson.name
    end

    it 'is listed on the deleted lessons page for an author' do
      lesson.destroy
      visit section_lessons_path(section) + "?deleted=true"
      expect(page).to have_content lesson.name
    end

    it 'can be deleted' do
      visit edit_section_lesson_path(section, lesson)
      click_link 'Delete ' + lesson.name
      expect(page).to have_content 'Lesson deleted.'
    end

    it 'is not visible to a student' do
      lesson.destroy
      login_as(student, scope: :user)
      visit section_lessons_path(section) + "?deleted=true"
      click_link lesson.name
      expect(page).to_not have_content lesson.content
    end

    it 'can be restored' do
      lesson.destroy
      visit table_of_contents_path
      click_link 'View deleted lessons'
      click_link lesson.name
      click_button 'Restore'
      expect(page).to have_content 'Lesson restored'
    end
  end

  context 'searching' do
    let!(:lesson) { FactoryGirl.create :lesson }

    it 'lets you search for lessons' do
      visit table_of_contents_path
      fill_in 'Search for:', with: lesson.content.split.last
      click_button 'Search'
      expect(page).to have_content lesson.name
    end
  end
end
