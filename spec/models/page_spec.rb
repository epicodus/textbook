require 'spec_helper'

describe Page do
  it {should allow_mass_assignment_of :title}
  it {should allow_mass_assignment_of :body}
  it {should allow_mass_assignment_of :section_id}
  it {should allow_mass_assignment_of :number}

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}
  it {should validate_presence_of :section}
  it {should validate_presence_of :number}
  it {should validate_numericality_of(:number).only_integer}

  it {should belong_to :section}

  it 'sorts by the number by default' do
    last_page = FactoryGirl.create :page, :number => 9
    (2..8).each {|number| FactoryGirl.create :page, :number => number}
    first_page = FactoryGirl.create :page, :number => 1
    Page.first.should eq first_page
    Page.last.should eq last_page
  end

  context '#next' do
    it 'returns the page in the current section with the next-highest number than the current page' do
      current_section = FactoryGirl.create :section
      current_page = FactoryGirl.create :page, :section => current_section, :number => 1
      another_section = FactoryGirl.create :section
      page_from_another_section = FactoryGirl.create :page, :section => another_section, :number => 2
      next_page = FactoryGirl.create :page, :section => current_section, :number => 3
      current_page.next.should eq next_page
    end
  end

  context '#previous' do
    it 'returns the page in the current section with the next-lowest number than the current page' do
      current_section = FactoryGirl.create :section
      current_page = FactoryGirl.create :page, :section => current_section, :number => 3
      another_section = FactoryGirl.create :section
      page_from_another_section = FactoryGirl.create :page, :section => another_section, :number => 2
      previous_page = FactoryGirl.create :page, :section => current_section, :number => 1
      current_page.previous.should eq previous_page
    end
  end

  context '#next_page?' do
    it 'returns false if there is no next page' do
      current_page = FactoryGirl.create :page
      current_page.next_page?.should be_false
    end

    it 'returns true if there is a next page' do
      current_section = FactoryGirl.create :section
      current_page = FactoryGirl.create :page, :section => current_section, :number => 1
      next_page = FactoryGirl.create :page, :section => current_section, :number => 2
      current_page.next_page?.should be_true
    end
  end

  context '#previous_page?' do
    it 'returns false if there is no previous page' do
      current_page = FactoryGirl.create :page
      current_page.previous_page?.should be_false
    end

    it 'returns true if there is a previous page' do
      current_section = FactoryGirl.create :section
      current_page = FactoryGirl.create :page, :section => current_section, :number => 2
      previous_page = FactoryGirl.create :page, :section => current_section, :number => 1
      current_page.previous_page?.should be_true
    end
  end
end
