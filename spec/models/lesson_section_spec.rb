require 'spec_helper'

describe LessonSection do

  it { should validate_presence_of :section }
  it { should validate_presence_of :lesson }

  describe 'default scope' do
    let!(:section) { FactoryGirl.create(:section) }
    let!(:last_lesson) { FactoryGirl.create :lesson, number: 4, section: section }
    let!(:third_lesson) { FactoryGirl.create :lesson, number: 3, section: section }
    let!(:second_lesson) { FactoryGirl.create :lesson, number: 2, section: section }
    let!(:first_lesson) { FactoryGirl.create :lesson, number: 1, section: section }
    let!(:last_lesson_section) { LessonSection.find_by(lesson_id: last_lesson.id) }
    let!(:first_lesson_section) { LessonSection.find_by(lesson_id: first_lesson.id) }

    it 'sorts by the number by default' do
      expect(LessonSection.first).to eq first_lesson_section
      expect(LessonSection.last).to eq last_lesson_section
    end
  end
end
