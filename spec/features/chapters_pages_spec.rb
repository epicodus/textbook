require 'spec_helper'

describe Chapter, js: true do
  let(:author) { FactoryGirl.create(:author) }
  let(:student) { FactoryGirl.create(:student) }
  let!(:chapter) { FactoryGirl.create(:chapter) }

  it 'can be created by an author' do
    login_as(author, scope: :user)
    visit table_of_contents_path
    click_link 'New chapter'
    fill_in 'Name', with: 'Awesome chapter'
    fill_in 'Chapter number', with: '1'
    click_button 'Create Chapter'
    page.should have_content 'Awesome chapter'
  end

  it 'displays errors if you try to save an invalid chapter' do
    login_as(author, scope: :user)
    visit table_of_contents_path
    click_link 'New chapter'
    click_button 'Create Chapter'
    page.should have_content "Please correct these problems:"
  end

  it 'cannot be created by a student' do
    login_as(student, scope: :user)
    visit table_of_contents_path
    page.should_not have_content 'New chapter'
    visit new_chapter_path
    page.should_not have_content 'New'
  end

  it 'can be edited by an author' do
    login_as(author, scope: :user)
    visit edit_chapter_path(chapter)
    fill_in 'Name', with: 'New awesome chapter'
    click_button 'Update Chapter'
    expect(page).to have_content 'Chapter updated'
  end

  it 'cannot be edited by a student' do
    login_as(student, scope: :user)
    visit table_of_contents_path
    page.should_not have_content 'edit'
    visit edit_chapter_path chapter
    page.should_not have_content 'Edit'
  end

  it 'can be deleted by an author' do
    login_as(author, scope: :user)
    visit table_of_contents_path
    click_link "delete_chapter_#{chapter.id}"
    page.should_not have_content chapter.name
  end

  it 'cannot be deleted by a student' do
    login_as(student, scope: :user)
    visit table_of_contents_path
    page.should_not have_content 'delete'
  end
end
