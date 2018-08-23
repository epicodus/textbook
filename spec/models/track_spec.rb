describe Track do
  it { should validate_presence_of :name }

  it 'validates uniqueness of name' do
    FactoryBot.create :track
    should validate_uniqueness_of :name
  end

  it 'validates that a track always has a number' do
    track = FactoryBot.create(:track)
    expect(track.update(number: nil)).to be false
  end

  it { should have_and_belong_to_many(:courses) }

  it 'sorts by the number by default' do
    first_track = FactoryBot.create :track
    second_track = FactoryBot.create :track
    last_track = FactoryBot.create :track
    expect(Track.first).to eq first_track
    expect(Track.last).to eq last_track
  end

  it 'updates the slug when a track name is updated' do
    track = FactoryBot.create(:track)
    track.update(name: 'New awesome track')
    expect(track.slug).to eq 'new-awesome-track'
  end
end
