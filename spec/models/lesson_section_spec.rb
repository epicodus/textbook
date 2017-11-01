describe LessonSection do

  it { should validate_presence_of :section }

  describe 'validations' do
    it 'validates that a lesson section always has a number' do
      section = FactoryBot.create(:section)
      lesson = FactoryBot.create(:lesson)
      lesson_section = LessonSection.create(section_id: section.id, lesson_id: lesson.id)
      expect(lesson_section.update(number: nil)).to be false
    end

    it 'validates that a lesson section always has a number that is an integer' do
      section = FactoryBot.create(:section)
      lesson = FactoryBot.create(:lesson)
      lesson_section = LessonSection.create(section_id: section.id, lesson_id: lesson.id)
      expect(lesson_section.update(number: 1.7)).to be false
    end
  end

  describe 'default scope' do
    let!(:section) { FactoryBot.create(:section) }
    let!(:first_lesson) { FactoryBot.create :lesson, section: section }
    let!(:second_lesson) { FactoryBot.create :lesson, section: section }
    let!(:third_lesson) { FactoryBot.create :lesson, section: section }
    let!(:last_lesson) { FactoryBot.create :lesson, section: section }
    let!(:last_lesson_section) { LessonSection.find_by(lesson_id: last_lesson.id) }
    let!(:first_lesson_section) { LessonSection.find_by(lesson_id: first_lesson.id) }

    it 'sorts by the number by default' do
      expect(LessonSection.first).to eq first_lesson_section
      expect(LessonSection.last).to eq last_lesson_section
    end
  end
end
