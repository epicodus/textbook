describe Section do
  it { should belong_to :course }
  it { should have_many(:lessons).dependent(:destroy) }

  it "validates the presence of name" do
    section = FactoryBot.build(:section, name: nil)
    expect(section.valid?).to be false
  end

  it 'validates that a section always has a number' do
    section = FactoryBot.create(:section)
    expect(section.update(number: nil)).to be false
  end

  describe 'default scope' do
    let(:course) { FactoryBot.create(:course) }
    let(:last_section) { FactoryBot.create :section, course: course}
    let(:first_section) { FactoryBot.create(:section, course: course) }

    it 'sorts by the number by default' do
      first_section.update(number: 1)
      last_section.update(number: 2)
      expect(course.sections.first).to eq first_section
      expect(course.sections.last).to eq last_section
    end
  end

  describe '.where_public' do
    it 'returns only public lessons' do
      public_lesson = FactoryBot.create(:lesson, public: true)
      private_lesson = FactoryBot.create(:lesson, public: false)
      expect(Lesson.where_public).to eq [public_lesson]
    end
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
    it 'validates that name is not tracks' do
      section = FactoryBot.build(:section, name: 'Tracks')
      expect(section.valid?).to be false
    end
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
    expect(new_section.lessons.first.content).to eq section.lessons.first.content
    expect(new_section.lessons.first).to_not eq section.lessons.first
  end

  describe '#build_section' do
    it 'builds section from github when URL included' do
      allow_any_instance_of(GithubReader).to receive(:parse_layout_file).and_return([{:day=>"monday", :lessons=>[{:title=>"test title", :filename=>"README.md", :work_type=>"lesson", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/main/static_for_automated_testing/README.md"}]}])
      allow_any_instance_of(Lesson).to receive(:update_from_github)
      section = FactoryBot.create(:section, layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/main/static_for_automated_testing/layout.yaml")
      lesson = section.lessons.first
      expect(lesson.name).to eq 'test title'
      expect(lesson.content).to eq 'Lesson queued for update... hit refresh soon!'
      expect(lesson.day_of_week).to eq 'monday'
      expect(lesson.work_type).to eq 'lesson'
    end

    it 'rebuilds section when layout file path changed' do
      section = FactoryBot.create(:section, layout_file_path: nil)
      allow_any_instance_of(Section).to receive(:build_section).and_return({})
      expect_any_instance_of(Section).to receive(:build_section)
      section.update(layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/main/static_for_automated_testing/layout.yaml")
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
end
