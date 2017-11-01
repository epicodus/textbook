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
