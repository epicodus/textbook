require 'spec_helper'


describe 'navigation' do
  let(:section) { FactoryBot.create :section }

  it 'allows navbar navigation to previous page when available' do
    lesson_1 = FactoryBot.create(:lesson, number: 1, section: section, content: '11111')
    lesson_2 = FactoryBot.create(:lesson, number: 2, section: section, content: '22222')
    visit course_section_lesson_path(section.course, section, lesson_2)
    click_on('navbar-previous')
    expect(page).to have_content '11111'
  end

  it 'allows navbar navigation to next page when available' do
    lesson_1 = FactoryBot.create(:lesson, number: 1, section: section, content: '11111')
    lesson_2 = FactoryBot.create(:lesson, number: 2, section: section, content: '22222')
    visit course_section_lesson_path(section.course, section, lesson_1)
    click_on('navbar-next')
    expect(page).to have_content '22222'
  end

  it 'allows footer navigation to previous page when available' do
    lesson_1 = FactoryBot.create(:lesson, number: 1, section: section, content: '11111')
    lesson_2 = FactoryBot.create(:lesson, number: 2, section: section, content: '22222')
    visit course_section_lesson_path(section.course, section, lesson_2)
    click_on('navbar-bottom-previous-link')
    expect(page).to have_content '11111'
  end

  it 'allows footer navigation to next page when available' do
    lesson_1 = FactoryBot.create(:lesson, number: 1, section: section, content: '11111')
    lesson_2 = FactoryBot.create(:lesson, number: 2, section: section, content: '22222')
    visit course_section_lesson_path(section.course, section, lesson_1)
    click_on('navbar-bottom-next-link')
    expect(page).to have_content '22222'
  end

  it 'does not allow navigation to previous page when not available' do
    lesson_2 = FactoryBot.create(:lesson, number: 2, section: section, content: '22222')
    visit course_section_lesson_path(section.course, section, lesson_2)
    expect(page).to_not have_content 'Previous'
    expect(page).to_not have_content 'previous'
  end

  it 'does not allow navigation to next page when not available' do
    lesson_2 = FactoryBot.create(:lesson, number: 2, section: section, content: '22222')
    visit course_section_lesson_path(section.course, section, lesson_2)
    expect(page).to_not have_content 'Next'
    expect(page).to_not have_content 'next'
  end
end
