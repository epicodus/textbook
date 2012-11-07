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
    it 'returns the page with sort order one higher than the current page' do
      2.times {FactoryGirl.create :page}
      current_page = Page.first
      next_page = current_page.next
      next_page.sort_order.should eq current_page.sort_order + 1
    end
  end

  context '#previous' do
    it 'returns the page with sort order one lower than the current page' do
      2.times {FactoryGirl.create :page}
      current_page = Page.last
      previous_page = current_page.previous
      previous_page.sort_order.should eq current_page.sort_order - 1
    end
  end
end
