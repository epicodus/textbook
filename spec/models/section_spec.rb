require 'spec_helper'

describe Section do
  it {should validate_presence_of :name}
  it {should validate_presence_of :number}
  it {should validate_numericality_of(:number).only_integer}
  it {should validate_presence_of :chapter}


  it 'validates uniqueness of name' do
    FactoryGirl.create :section
    should validate_uniqueness_of :name
  end

  it {should have_many(:lessons).dependent(:destroy)}
  it {should belong_to :chapter}

  it 'sorts by the number by default' do
    last_section = FactoryGirl.create :section, :number => 2
    first_section = FactoryGirl.create :section, :number => 1
    Section.first.should eq first_section
    Section.last.should eq last_section
  end
end
