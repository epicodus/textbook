require 'spec_helper'

describe Chapter do
  it { should validate_presence_of :name }
  it { should validate_presence_of :number }

  it 'validates uniqueness of name' do
    FactoryGirl.create :chapter
    should validate_uniqueness_of :name
  end

  it { should have_many(:sections).dependent(:destroy) }
  it { should have_many(:lessons).through(:sections) }

  it 'sorts by the number by default' do
    last_chapter = FactoryGirl.create :chapter, :number => 9
    (2..8).each { |number| FactoryGirl.create :chapter, :number => number }
    first_chapter = FactoryGirl.create :chapter, :number => 1
    expect(Chapter.first).to eq first_chapter
    expect(Chapter.last).to eq last_chapter
  end

end
