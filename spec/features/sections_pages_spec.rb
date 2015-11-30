require 'spec_helper'

describe Section, js: true do
  let(:author) { FactoryGirl.create(:author) }
  let(:student) { FactoryGirl.create(:student) }
  let!(:course) { FactoryGirl.create(:course) }
  let!(:section) { FactoryGirl.create(:section) }

  it 'can be created by an author' do
    login_as(author, scope: :user)
    visit course_path(course)
    click_link 'New Section'
    fill_in 'Name', with: 'Awesome section'
    fill_in 'Section week', with: '1'
    click_button 'Create Section'
    expect(page).to have_content 'Awesome section'
  end

  it 'displays errors if you try to save an invalid section' do
    login_as(author, scope: :user)
    visit course_path(course)
    click_link 'New Section'
    click_button 'Create Section'
    expect(page).to have_content "Please correct these problems:"
  end

  it 'cannot be created by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'New Section'
    visit new_course_section_path(course)
    expect(page).to_not have_content 'New'
  end

  it 'can be edited by an author' do
    login_as(author, scope: :user)
    visit edit_course_section_path(course, section)
    fill_in 'Name', with: 'New awesome section'
    fill_in 'Section week', with: '3'
    click_button 'Update Section'
    expect(page).to have_content 'Section updated'
  end

  it 'displays errors if you try to save an invalid section when editing' do
    login_as(author, scope: :user)
    visit edit_course_section_path(course, section)
    fill_in 'Name', with: ''
    click_button 'Update Section'
    expect(page).to have_content "Please correct these problems:"
  end

  it 'cannot be edited by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'edit'
    visit edit_course_section_path(course, section)
    expect(page).to_not have_content 'Edit'
  end

  it 'can be deleted by an author' do
    login_as(author, scope: :user)
    visit course_path(section.course)
    click_link "delete_section_#{section.id}"
    expect(page).to_not have_content section.name
  end

  it 'cannot be deleted by a student' do
    login_as(student, scope: :user)
    visit courses_path
    expect(page).to_not have_content 'delete'
  end

  it 'is visible to an author' do
    login_as(author, scope: :user)
    private_section = FactoryGirl.create :section, course: course, public: false
    visit section_show_path(private_section)
    expect(page).to have_content private_section.name
  end

  it 'is not visible to a student' do
    login_as(student, scope: :user)
    private_section = FactoryGirl.create :section, course: course, public: false
    visit section_show_path(private_section)
    expect(page).to have_content "Sorry, that section isn't finished yet."
  end

  it 'is not visible on the course show page when private' do
    login_as(student, scope: :user)
    private_section = FactoryGirl.create :section, course: course, public: false
    public_section = FactoryGirl.create :section, course: course
    visit course_path(course)
    expect(page).to_not have_content private_section.name
  end
end
