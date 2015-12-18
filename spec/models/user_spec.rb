describe User do
  context '#author?' do
    it 'should be false by default' do
      user = User.new
      expect(user.author?).to be false
    end

    it 'should be true if author is set to true' do
      user = User.new
      user.author = true
      user.save
      expect(user.author?).to be true
    end
  end
end
