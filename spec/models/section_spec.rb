require 'spec_helper'

describe Section do
  it {should allow_mass_assignment_of :name}
  it {should validate_presence_of :name}
end
