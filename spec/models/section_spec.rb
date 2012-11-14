require 'spec_helper'

describe Section do
  it {should allow_mass_assignment_of :name}
  it {should allow_mass_assignment_of :number}
  it {should allow_mass_assignment_of :chapter_id}

  it {should validate_presence_of :name}
  it {should validate_presence_of :number}
  it {should validate_numericality_of(:number).only_integer}

  it {should have_many :pages}
  it {should belong_to :chapter}

  it 'sorts by the number by default' do
    last_section = FactoryGirl.create :section, :number => 9
    (2..8).each {|number| FactoryGirl.create :section, :number => number}
    first_section = FactoryGirl.create :section, :number => 1
    Section.first.should eq first_section
    Section.last.should eq last_section
  end

  context '#next' do
    it 'returns the section in the current chapter with the next-highest number than the current section' do
      chapter = FactoryGirl.create :chapter
      current_section = FactoryGirl.create :section, :number => 2, :chapter => chapter
      previous_section = FactoryGirl.create :section, :number => 1, :chapter => chapter
      next_section = FactoryGirl.create :section, :number => 3, :chapter => chapter
      current_section.next.should eq next_section
    end
  end

  context '#previous' do
    it 'returns the section in the current chapter with the next-lowest number than the current section' do
      chapter = FactoryGirl.create :chapter
      current_section = FactoryGirl.create :section, :number => 2, :chapter => chapter
      previous_section = FactoryGirl.create :section, :number => 1, :chapter => chapter
      next_section = FactoryGirl.create :section, :number => 3, :chapter => chapter
      current_section.previous.should eq previous_section
    end
  end
end
