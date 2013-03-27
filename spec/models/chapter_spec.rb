require 'spec_helper'

describe Chapter do
  it {should allow_mass_assignment_of :name}
  it {should allow_mass_assignment_of :number}
  it {should allow_mass_assignment_of :public}
  it {should allow_mass_assignment_of :sections_attributes}
  it {should allow_mass_assignment_of :lessons_attributes}

  it {should validate_presence_of :name}
  it {should validate_presence_of :number}
  it {should validate_numericality_of(:number).only_integer}

  it 'validates uniqueness of name' do
    FactoryGirl.create :chapter
    should validate_uniqueness_of :name
  end

  it {should have_many :sections}
  it {should have_many(:lessons).through(:sections)}

  it 'sorts by the number by default' do
    last_chapter = FactoryGirl.create :chapter, :number => 9
    (2..8).each {|number| FactoryGirl.create :chapter, :number => number}
    first_chapter = FactoryGirl.create :chapter, :number => 1
    Chapter.first.should eq first_chapter
    Chapter.last.should eq last_chapter
  end

end
