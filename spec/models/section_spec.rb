require 'spec_helper'

describe Section do
  it { should validate_presence_of :number }
  it { should validate_presence_of :course }
  it { should have_many(:lessons).through(:lesson_sections) }
  it { should belong_to :course }

  it "validates the presence of name" do
    section = FactoryGirl.build(:section, name: nil)
    expect(section.valid?).to be false
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
    it 'validates that name is not table of contents' do
      section = FactoryGirl.build(:section, name: 'Table of contents')
      expect(section.valid?).to be false
    end
  end

  it 'validates uniqueness of name' do
    FactoryGirl.create :section
    should validate_uniqueness_of :name
  end

  it 'sorts by the number by default' do
    last_section = FactoryGirl.create :section, :number => 2
    first_section = FactoryGirl.create :section, :number => 1
    expect(Section.first).to eq first_section
    expect(Section.last).to eq last_section
  end
end
