require 'spec_helper'

describe Page do
  it {should allow_mass_assignment_of :title}
  it {should allow_mass_assignment_of :body}
  it {should allow_mass_assignment_of :section_id}
  it {should validate_presence_of :title}
  it {should validate_presence_of :body}
  it {should belong_to :section}
end
