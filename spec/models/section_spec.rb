require 'spec_helper'

describe Section do
  it { should validate_presence_of :course }
  it { should have_many(:lessons).through(:lesson_sections) }
  it { should belong_to :course }

  it "validates the presence of name" do
    section = FactoryGirl.build(:section, name: nil)
    expect(section.valid?).to be false
  end

  it 'validates that a section always has a number' do
    section = FactoryGirl.create(:section)
    expect(section.update(number: nil)).to be false
  end

  describe 'validates that name is not a top-level route' do
    it 'validates that name is not sections' do
      section = FactoryGirl.build(:section, name: 'Sections')
      expect(section.valid?).to be false
    end
    it 'validates that name is not lessons' do
      section = FactoryGirl.build(:section, name: 'Lessons')
      expect(section.valid?).to be false
    end
    it 'validates that name is not courses' do
      section = FactoryGirl.build(:section, name: 'Courses')
      expect(section.valid?).to be false
    end
  end

  it 'validates uniqueness of name' do
    FactoryGirl.create :section
    should validate_uniqueness_of :name
  end

  it 'sorts by the number by default' do
    course = FactoryGirl.create :course
    first_section = FactoryGirl.create :section, course: course
    last_section = FactoryGirl.create :section, course: course
    expect(Section.first).to eq first_section
    expect(Section.last).to eq last_section
  end

  it 'returns sections that are public' do
    public_section_1 = FactoryGirl.create(:section)
    public_section_2 = FactoryGirl.create(:section)
    private_section = FactoryGirl.create(:section, public: false)
    expect(Section.only_public).to eq [public_section_1, public_section_2]
  end
end
