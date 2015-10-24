require 'spec_helper'

describe Chapter, :js => true do
  it 'can be created by an author' do
    author = FactoryGirl.create :author
    login_as(author, :scope => :user)
    visit table_of_contents_path
    click_link 'New chapter'
    fill_in 'Name', :with => 'Awesome chapter'
    fill_in 'Chapter number', :with => '1'
    click_button 'Create Chapter'
    page.should have_content 'Awesome chapter'
  end

  it 'displays errors if you try to save an invalid chapter' do
    author = FactoryGirl.create :author
    login_as(author, :scope => :user)
    visit table_of_contents_path
    click_link 'New chapter'
    click_button 'Create Chapter'
    page.should have_content "Please correct these problems:"
  end

  it 'cannot be created by a student' do
    student = FactoryGirl.create :student
    login_as(student, :scope => :user)
    visit table_of_contents_path
    page.should_not have_content 'New chapter'
    visit new_chapter_path
    page.should_not have_content 'New'
  end

  it 'can be edited by an author' do
    author = FactoryGirl.create :author
    login_as(author, :scope => :user)
    chapter = FactoryGirl.create :chapter
    visit table_of_contents_path
    click_link "edit_chapter_#{chapter.id}"
    page.should have_content 'Edit'
  end

  it 'cannot be edited by a student' do
    student = FactoryGirl.create :student
    login_as(student, :scope => :user)
    chapter = FactoryGirl.create :chapter
    visit table_of_contents_path
    page.should_not have_content 'edit'
    visit edit_chapter_path chapter
    page.should_not have_content 'Edit'
  end

  it 'can be deleted by an author' do
    author = FactoryGirl.create :author
    login_as(author, :scope => :user)
    chapter = FactoryGirl.create :chapter
    visit table_of_contents_path
    click_link "delete_chapter_#{chapter.id}"
    page.should_not have_content chapter.name
  end

  it 'cannot be deleted by a student' do
    student = FactoryGirl.create :student
    login_as(student, :scope => :user)
    chapter = FactoryGirl.create :chapter
    visit table_of_contents_path
    page.should_not have_content 'delete'
  end

  it "be able to drag a lesson" do
    author = FactoryGirl.create :author
    login_as(author, :scope => :user)
    chapter = FactoryGirl.create :chapter
    section_one = FactoryGirl.create :section, :chapter_id => chapter.id
    section_two = FactoryGirl.create :section, :chapter_id => chapter.id
    lesson_one = FactoryGirl.create :lesson, :section_id => section_one.id
    lesson_two = FactoryGirl.create :lesson, :section_id => section_two.id
    visit table_of_contents_path
    first_sortable = page.all('li.ui-sortable-handle')[0]
    second_sortable = page.all('li.ui-sortable-handle')[1]
    first_sortable.drag_to(second_sortable)
    expect(page.all('li.ui-sortable-handle')[0]).to eq second_sortable
  end
end
