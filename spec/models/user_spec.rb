require 'spec_helper'

describe User do
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
