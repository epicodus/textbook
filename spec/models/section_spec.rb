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

  it 'clears layout_file_path when section deleted' do
    allow_any_instance_of(Section).to receive(:build_section)
    section = FactoryBot.create(:section, layout_file_path: 'https://example.com')
    section.destroy
    expect(section.layout_file_path).to eq nil
  end

  describe 'layout_file_path callback' do
    it 'runs #build_section when layout_file_path present' do
      section = FactoryBot.build(:section, layout_file_path: "test")
      expect(section).to receive(:build_section)
      section.save
    end

    it 'does not run #build_section when layout_file_path not present' do
      section = FactoryBot.build(:section, layout_file_path: nil)
      expect(section).to_not receive(:build_section)
      section.save
    end
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

  describe '#build_section' do
    it 'builds section from github when URL included' do
      allow_any_instance_of(GithubReader).to receive(:parse_layout_file).and_return([{:day=>"monday", :lessons=>[{:title=>"test title", :filename=>"README.md", :work_type=>"lesson", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/README.md"}]}])
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({ content: 'test content' })
      section = FactoryBot.create(:section, layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml")
      lesson = section.lessons.first
      lesson_section = section.lesson_sections.first
      expect(lesson.name).to eq 'test title'
      expect(lesson.content).to eq 'test content'
      expect(lesson_section.day_of_week).to eq 'monday'
      expect(lesson_section.work_type).to eq 'lesson'
    end

    it 'rebuilds section when layout file path changed' do
      section = FactoryBot.create(:section, layout_file_path: nil)
      allow_any_instance_of(Section).to receive(:build_section).and_return({})
      expect_any_instance_of(Section).to receive(:build_section)
      section.update(layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml")
    end

    it 'does not build section from github when URL not included' do
      expect_any_instance_of(GithubReader).to_not receive(:parse_layout_file)
      section = FactoryBot.create(:section, layout_file_path: nil)
    end

    it 'raises exception when invalid layout file path' do
      expect { FactoryBot.create(:section, layout_file_path: "https://example.com") }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: Invalid Github path")
      expect(Section.all).to eq []
    end
  end

  describe '#empty_section!' do
    it 'erases all lesson_sections & actual lessons if lesson unique to this section' do
      section = FactoryBot.create(:section)
      2.times { FactoryBot.create(:lesson, section: section) }
      section.empty_section!
      expect(Lesson.with_deleted.count).to eq 0
      expect(LessonSection.with_deleted.count).to eq 0
    end

    it 'does not erase lesson if belongs to other sections' do
      lesson = FactoryBot.create(:lesson)
      section = lesson.sections.first
      section2 = FactoryBot.create(:section, lessons: [lesson])
      section.empty_section!
      expect(section2.lessons.count).to eq 1
      expect(section2.lesson_sections.count).to eq 1
      expect(LessonSection.with_deleted.count).to eq 1
    end
  end
end
