describe Course do
  it { should validate_presence_of :name }

  it 'validates that a course always has a number' do
    course = FactoryBot.create(:course)
    expect(course.update(number: nil)).to be false
  end

  it 'validates uniqueness of name' do
    FactoryBot.create :course
    should validate_uniqueness_of :name
  end

  it { should have_and_belong_to_many(:tracks) }
  it { should have_many(:sections).dependent(:destroy) }
  it { should have_many(:lessons).through(:sections) }

  it 'sorts by the number by default' do
    first_course = FactoryBot.create :course
    second_course = FactoryBot.create :course
    last_course = FactoryBot.create :course
    expect(Course.first).to eq first_course
    expect(Course.last).to eq last_course
  end

  describe '.where_public' do
    it 'returns only public lessons' do
      public_lesson = FactoryBot.create(:lesson, public: true)
      private_lesson = FactoryBot.create(:lesson, public: false)
      expect(Lesson.where_public).to eq [public_lesson]
    end
  end

  it 'returns courses that have sections' do
    course_with_section = FactoryBot.create(:course)
    course_without_section = FactoryBot.create(:course)
    section = FactoryBot.create(:section, course: course_with_section)
    expect(Course.with_sections).to eq [course_with_section]
  end

  it 'updates the slug when a course name is updated' do
    course = FactoryBot.create(:course)
    course.update(name: 'New awesome course')
    expect(course.slug).to eq 'new-awesome-course'
  end

  it 'duplicates a course and its sections' do
    course = FactoryBot.create(:course)
    section1 = FactoryBot.create(:section, course: course)
    section2 = FactoryBot.create(:section, course: course)
    new_course = course.deep_clone
    expect(new_course).to_not eq course
    expect(new_course.name).to eq course.name + ' (copy)'
    expect(new_course.public).to eq false
    expect(new_course.sections).to_not eq course.sections
    expect(new_course.sections.map {|s| s.name}).to eq course.sections.map {|s| s.name}
  end

  it 'duplicates a course and its sections and lessons' do
    course = FactoryBot.create(:course)
    section1 = FactoryBot.create(:section, course: course)
    section2 = FactoryBot.create(:section, course: course)
    lesson1 = FactoryBot.create(:lesson, section: section1)
    lesson2 = FactoryBot.create(:lesson, section: section1)
    lesson3 = FactoryBot.create(:lesson, section: section2)
    new_course = course.deep_clone
    expect(new_course.sections.first.lessons.first.content).to eq course.sections.first.lessons.first.content
    expect(new_course.sections.last.lessons.last.content).to eq course.sections.last.lessons.last.content
  end
end
