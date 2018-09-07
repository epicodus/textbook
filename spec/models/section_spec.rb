describe Section do
  it { should validate_presence_of :course }
  it { should have_many(:lessons).through(:lesson_sections) }
  it { should belong_to :course }

  it "validates the presence of name" do
    section = FactoryBot.build(:section, name: nil)
    expect(section.valid?).to be false
  end

  it 'validates that a section always has a number' do
    section = FactoryBot.create(:section)
    expect(section.update(number: nil)).to be false
  end

  describe 'validates that name is not a top-level route' do
    it 'validates that name is not sections' do
      section = FactoryBot.build(:section, name: 'Sections')
      expect(section.valid?).to be false
    end
    it 'validates that name is not lessons' do
      section = FactoryBot.build(:section, name: 'Lessons')
      expect(section.valid?).to be false
    end
    it 'validates that name is not courses' do
      section = FactoryBot.build(:section, name: 'Courses')
      expect(section.valid?).to be false
    end
  end

  xit 'validates uniqueness of name' do # FIXME pending https://github.com/thoughtbot/shoulda-matchers/issues/814
    FactoryBot.create :section
    should validate_uniqueness_of(:name).scoped_to(:course)
  end

  it 'sorts by the number by default' do
    course = FactoryBot.create :course
    first_section = FactoryBot.create :section, course: course
    last_section = FactoryBot.create :section, course: course
    expect(Section.first).to eq first_section
    expect(Section.last).to eq last_section
  end

  it 'updates the slug when a section name is updated' do
    section = FactoryBot.create(:section)
    section.update(name: 'New awesome section')
    expect(section.slug).to eq 'new-awesome-section'
  end

  it 'duplicates a section and links to same lessons' do
    section = FactoryBot.create(:section)
    lesson1 = FactoryBot.create(:lesson, section: section)
    lesson2 = FactoryBot.create(:lesson, section: section)
    other_course = FactoryBot.create(:course, name: "other course")
    new_section = section.deep_clone(other_course)
    expect(new_section).to_not eq section
    expect(new_section.name).to eq section.name
    expect(new_section.public).to eq section.public
    expect(new_section.lesson_sections).to_not eq section.lessons
    expect(new_section.lessons).to eq section.lessons
  end

  it 'duplicates lessons within section' do
    section = FactoryBot.create(:section)
    allow_any_instance_of(Lesson).to receive(:update_from_github)
    lesson1 = FactoryBot.create(:lesson, section: section, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    lesson2 = FactoryBot.create(:lesson, section: section)
    section.detach_lessons
    expect(section).to eq section
    new_lesson1 = section.lessons.find_by(name: lesson1.name)
    expect(new_lesson1).to_not eq lesson1
    expect(new_lesson1.slug).to_not eq lesson1.slug
    expect(new_lesson1.github_path).to eq nil
    expect(new_lesson1.name).to eq lesson1.name
    expect(new_lesson1.content).to eq lesson1.content
    expect(new_lesson1.cheat_sheet).to eq lesson1.cheat_sheet
    expect(new_lesson1.update_warning).to eq lesson1.update_warning
    expect(new_lesson1.teacher_notes).to eq lesson1.teacher_notes
    expect(new_lesson1.video_id).to eq lesson1.video_id
    expect(new_lesson1.public).to eq lesson1.public
  end

  context 'paranoia' do
    it 'archives destroyed section' do
      section = FactoryBot.create(:section)
      section.destroy
      expect(Section.count).to eq 0
      expect(Section.with_deleted.count).to eq 1
    end

    it 'restores archived section' do
      section = FactoryBot.create(:section)
      section.destroy
      section.restore
      expect(Section.count).to eq 1
    end
  end
end
