require 'spec_helper'

describe Section do
  it {should allow_mass_assignment_of :name}
  it {should allow_mass_assignment_of :sort_order}

  it {should validate_presence_of :name}
  it {should validate_presence_of :sort_order}
  it {should validate_numericality_of(:sort_order).only_integer}

  it {should have_many :pages}
end
