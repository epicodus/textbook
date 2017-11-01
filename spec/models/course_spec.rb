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

  it { should have_many(:sections).dependent(:destroy) }
  it { should have_many(:lessons).through(:sections) }

  it 'sorts by the number by default' do
    first_course = FactoryBot.create :course
    second_course = FactoryBot.create :course
    last_course = FactoryBot.create :course
    expect(Course.first).to eq first_course
    expect(Course.last).to eq last_course
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

  context 'paranoia' do
    it 'archives destroyed course' do
      course = FactoryBot.create(:course)
      course.destroy
      expect(Course.count).to eq 0
      expect(Course.with_deleted.count).to eq 1
    end

    it 'restores archived course' do
      course = FactoryBot.create(:course)
      course.destroy
      course.restore
      expect(Course.count).to eq 1
    end
  end
end
