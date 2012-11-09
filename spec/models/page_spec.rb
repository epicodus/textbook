require 'spec_helper'

describe Page do
  it {should allow_mass_assignment_of :title}
  it {should allow_mass_assignment_of :body}
  it {should allow_mass_assignment_of :section_id}
  it {should allow_mass_assignment_of :sort_order}

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}
  it {should validate_presence_of :section}
  it {should validate_presence_of :sort_order}
  it {should validate_numericality_of(:sort_order).only_integer}

  it {should belong_to :section}

  it 'sorts by the sort order by default' do
    last_page = FactoryGirl.create :page, :sort_order => 9
    (2..8).each {|number| FactoryGirl.create :page, :sort_order => number}
    first_page = FactoryGirl.create :page, :sort_order => 1
    Page.first.should eq first_page
    Page.last.should eq last_page
  end

  context '#next' do
    it 'returns the page in the current section with the next-highest sort order than the current page' do
      current_section = FactoryGirl.create :section
      current_page = FactoryGirl.create :page, :section => current_section, :sort_order => 1
      another_section = FactoryGirl.create :section
      page_from_another_section = FactoryGirl.create :page, :section => another_section, :sort_order => 2
      next_page = FactoryGirl.create :page, :section => current_section, :sort_order => 3
      current_page.next.should eq next_page
    end
  end

  context '#previous' do
    it 'returns the page in the current section with the next-lowest sort order than the current page' do
      current_section = FactoryGirl.create :section
      current_page = FactoryGirl.create :page, :section => current_section, :sort_order => 3
      another_section = FactoryGirl.create :section
      page_from_another_section = FactoryGirl.create :page, :section => another_section, :sort_order => 2
      previous_page = FactoryGirl.create :page, :section => current_section, :sort_order => 1
      current_page.previous.should eq previous_page
    end
  end
end
