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

  it 'displays track show page if more than one course' do
    student = FactoryBot.create(:student)
    course = FactoryBot.create(:course)
    course2 = FactoryBot.create(:course)
    track = FactoryBot.create(:track, courses: [course, course2])
    login_as(student, scope: :user)
    visit track_path(track)
    expect(current_path).to eq track_path(track)
  end

  it 'redirects to course page if track has only one course' do
    student = FactoryBot.create(:student)
    course = FactoryBot.create(:course)
    track = FactoryBot.create(:track, courses: [course])
    login_as(student, scope: :user)
    visit track_path(track)
    expect(current_path).to eq course_path(course)
  end

  it 'does not display private courses on track show page' do
    student = FactoryBot.create(:student)
    course = FactoryBot.create(:course, public: false)
    track = FactoryBot.create(:track, courses: [course])
    login_as(student, scope: :user)
    visit track_path(track)
    expect(page).to_not have_content course.name
  end

  it 'shows courses in correct order' do
    student = FactoryBot.create(:student)
    course = FactoryBot.create(:course, number: 1, level: 2)
    course2 = FactoryBot.create(:course, number: 2, level: 1)
    track = FactoryBot.create(:track, courses: [course, course2])
    login_as(student, scope: :user)
    visit track_path(track)
    expect(page).to have_content "#{course2.name} #{course.name}"
  end
end
