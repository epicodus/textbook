require 'spec_helper'

describe Course, js: true do
  let(:author) { FactoryBot.create(:author) }
  let(:student) { FactoryBot.create(:student) }
  let!(:course) { FactoryBot.create(:course) }

  it 'can be created by an author' do
    login_as(author, scope: :user)
    visit courses_path
    click_link 'New Course'
    fill_in 'Name', with: 'Awesome course'
    click_button 'Create Course'
    expect(page).to have_content 'Awesome course'
  end

  it 'displays errors if you try to save an invalid course' do
    login_as(author, scope: :user)
    visit courses_path
    click_link 'New Course'
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

  it 'displays errors if you try to save an invalid course when editing' do
    login_as(author, scope: :user)
    course = FactoryBot.create(:course)
    visit course_path(course)
    click_link 'Edit'
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
    expect(page).to have_content 'Course deleted.'
    expect(page).to have_content 'Deleted Courses: ' + course.name
  end

  it 'can be restored by an author' do
    course.destroy
    login_as(author, scope: :user)
    visit courses_path
    click_link "restore_course_#{course.id}"
    expect(page).to have_content course.name
    expect(page).to_not have_content 'Deleted Courses'
  end

  it 'cannot be deleted by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'delete'
  end

  it 'cannot be restored by a student' do
    course.destroy
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'Deleted Courses'
  end

  it 'is visible to an author' do
    login_as(author, scope: :user)
    private_course = FactoryBot.create :course, public: false
    visit course_path(private_course)
    expect(page).to have_content private_course.name
  end

  it 'is not visible to a student' do
    login_as(student, scope: :user)
    private_course = FactoryBot.create :course, public: false
    visit course_path(private_course)
    expect(page).to have_content "Sorry, that course isn't finished yet."
  end

  it 'is not visible on the course index page when private' do
    login_as(student, scope: :user)
    private_course = FactoryBot.create :course, public: false
    public_course = FactoryBot.create :course
    visit courses_path
    expect(page).to_not have_content private_course.name
  end
end
