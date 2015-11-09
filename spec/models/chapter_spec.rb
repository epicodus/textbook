require 'spec_helper'

describe Course do
  it { should validate_presence_of :name }
  it { should validate_presence_of :number }

  it 'validates uniqueness of name' do
    FactoryGirl.create :course
    should validate_uniqueness_of :name
  end

  it { should have_many(:sections).dependent(:destroy) }
  it { should have_many(:lessons).through(:sections) }

  it 'sorts by the number by default' do
    last_course = FactoryGirl.create :course, :number => 9
    (2..8).each { |number| FactoryGirl.create :course, :number => number }
    first_course = FactoryGirl.create :course, :number => 1
    expect(Course.first).to eq first_course
    expect(Course.last).to eq last_course
  end

end
