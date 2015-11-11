require 'spec_helper'

describe Course, js: true do
  let(:author) { FactoryGirl.create(:author) }
  let(:student) { FactoryGirl.create(:student) }
  let!(:course) { FactoryGirl.create(:course) }

  it 'can be created by an author' do
    login_as(author, scope: :user)
    visit courses_path
    click_link 'New course'
    fill_in 'Name', with: 'Awesome course'
    fill_in 'Course number', with: '1'
    click_button 'Create Course'
    expect(page).to have_content 'Awesome course'
  end

  xit 'displays errors if you try to save an invalid course' do
    login_as(author, scope: :user)
    visit courses_path
    click_link 'New course'
    click_button 'Create Course'
    expect(page).to have_content "Please correct these problems:"
  end

  it 'cannot be created by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'New course'
    visit new_course_path
    expect(page).to_not have_content 'New'
  end

  it 'can be edited by an author' do
    login_as(author, scope: :user)
    visit edit_course_path(course)
    fill_in 'Name', with: 'New awesome course'
    click_button 'Update Course'
    expect(page).to have_content 'Course updated'
  end

  xit 'displays errors if you try to save an invalid course when editing' do
    login_as(author, scope: :user)
    visit edit_course_path(course)
    fill_in 'Name', with: ''
    click_button 'Update Course'
    expect(page).to have_content "Please correct these problems:"
  end

  it 'cannot be edited by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'edit'
    visit edit_course_path course
    expect(page).to_not have_content 'Edit'
  end

  it 'can be deleted by an author' do
    login_as(author, scope: :user)
    visit course_path(course)
    click_link "delete_course_#{course.id}"
    expect(page).to_not have_content course.name
  end

  it 'cannot be deleted by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'delete'
  end
end
