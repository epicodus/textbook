require 'spec_helper'

describe Chapter do
  it {should allow_mass_assignment_of :name}
  it {should allow_mass_assignment_of :number}

  it {should validate_presence_of :name}
  it {should validate_presence_of :number}
  it {should validate_numericality_of(:number).only_integer}

  it {should have_many :sections}

  it 'sorts by the sort order by default' do
    last_chapter = FactoryGirl.create :chapter, :number => 9
    (2..8).each {|number| FactoryGirl.create :chapter, :number => number}
    first_chapter = FactoryGirl.create :chapter, :number => 1
    Chapter.first.should eq first_chapter
    Chapter.last.should eq last_chapter
  end

end
