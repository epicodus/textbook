describe Course do
  it { should validate_presence_of :name }

  it 'validates that a course always has a number' do
    course = FactoryGirl.create(:course)
    expect(course.update(number: nil)).to be false
  end

  it 'validates uniqueness of name' do
    FactoryGirl.create :course
    should validate_uniqueness_of :name
  end

  it { should have_many(:sections).dependent(:destroy) }
  it { should have_many(:lessons).through(:sections) }

  it 'sorts by the number by default' do
    first_course = FactoryGirl.create :course
    second_course = FactoryGirl.create :course
    last_course = FactoryGirl.create :course
    expect(Course.first).to eq first_course
    expect(Course.last).to eq last_course
  end

  it 'returns courses that have sections' do
    course_with_section = FactoryGirl.create(:course)
    course_without_section = FactoryGirl.create(:course)
    section = FactoryGirl.create(:section, course: course_with_section)
    expect(Course.with_sections).to eq [course_with_section]
  end

  it 'updates the slug when a course name is updated' do
    course = FactoryGirl.create(:course)
    course.update(name: 'New awesome course')
    expect(course.slug).to eq 'new-awesome-course'
  end

  context 'paranoia' do
    it 'archives destroyed course' do
      course = FactoryGirl.create(:course)
      course.destroy
      expect(Course.count).to eq 0
      expect(Course.with_deleted.count).to eq 1
    end

    it 'restores archived course' do
      course = FactoryGirl.create(:course)
      course.destroy
      course.restore
      expect(Course.count).to eq 1
    end
  end
end
