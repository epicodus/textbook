require 'spec_helper'

describe Track do
  it 'is visible to an author' do
    author = FactoryBot.create(:author)
    login_as(author, scope: :user)
    private_track = FactoryBot.create :track, public: false
    visit tracks_path
    expect(page).to have_content private_track.name
    expect(page).to have_content 'view all courses'
    visit track_path(private_track)
    expect(page).to have_content private_track.name
  end

  it 'is not visible to a student' do
    student = FactoryBot.create(:student)
    login_as(student, scope: :user)
    private_track = FactoryBot.create :track, public: false
    visit tracks_path
    expect(page).to_not have_content private_track.name
    expect(page).to_not have_content 'view all courses'
    visit track_path(private_track)
    expect(page).to have_content "Sorry, that track isn't finished yet."
  end
end
