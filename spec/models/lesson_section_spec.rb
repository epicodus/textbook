require 'spec_helper'

describe LessonSection do
  let(:section) { FactoryGirl.create(:section) }
  let(:last_lesson) { FactoryGirl.create :lesson, number: 4, section: section }
  let(:third_lesson) { FactoryGirl.create :lesson, number: 3, section: section }
  let(:second_lesson) { FactoryGirl.create :lesson, number: 2, section: section }
  let(:first_lesson) { FactoryGirl.create :lesson, number: 1, section: section }
  let(:last_lesson_section) { LessonSection.find_by(lesson_id: last_lesson.id) }
  let(:first_lesson_section) { LessonSection.find_by(lesson_id: first_lesson.id) }

  before do
    last_lesson_section.update(number: last_lesson.number)
    LessonSection.find_by(lesson_id: third_lesson.id).update(number: third_lesson.number)
    LessonSection.find_by(lesson_id: second_lesson.id).update(number: second_lesson.number)
    first_lesson_section.update(number: first_lesson.number)
  end

  it 'sorts by the number by default' do
    expect(LessonSection.first).to eq first_lesson_section
    expect(LessonSection.last).to eq last_lesson_section
  end
end
