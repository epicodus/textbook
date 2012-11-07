require 'spec_helper'

describe Section do
  it {should allow_mass_assignment_of :name}
  it {should allow_mass_assignment_of :sort_order}

  it {should validate_presence_of :name}
  it {should validate_presence_of :sort_order}
  it {should validate_numericality_of(:sort_order).only_integer}

  it {should have_many :pages}

  it 'sorts by the sort order by default' do
    last_section = FactoryGirl.create :section, :sort_order => 9
    (2..8).each {|number| FactoryGirl.create :section, :sort_order => number}
    first_section = FactoryGirl.create :section, :sort_order => 1
    Section.first.should eq first_section
    Section.last.should eq last_section
  end
end
