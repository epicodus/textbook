require 'spec_helper'

describe User do
  it {should allow_mass_assignment_of :email}
  it {should allow_mass_assignment_of :password}
  it {should allow_mass_assignment_of :password_confirmation}
  it {should allow_mass_assignment_of :remember_me}
  it {should_not allow_mass_assignment_of :author}

  context '#author?' do
    it 'should be false by default' do
      user = User.new
      user.author?.should be_false
    end

    it 'should be true if author is set to true' do
      user = User.new
      user.author = true
      user.save
      user.author?.should be_true
    end
  end
end
