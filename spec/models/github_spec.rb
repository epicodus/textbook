describe Github, vcr: true do
  it 'updates lesson content based on Github repo name & list of file paths' do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: ['README.md'], removed: [] })
    expect(lesson.reload.content).to include 'testing'
  end

  it 'marks lesson as private when removed from Github repo' do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: [], removed: ['README.md'] })
    expect(lesson.reload.public).to be false
  end

  it 'fetches lesson content from Github given github_path' do
    github_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md"
    expect(Github.get_content(github_path)[:content]).to include 'testing'
  end

  it 'parses layout file' do
    Github.parse_layout_file("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/test_week")
    # expect(section.lessons.any?).to eq true
    # expect(section.lesson_sections.any?).to eq true
    # expect(section.lessons.find_by(name: 'Hash Class').present?).to eq true
    # expect(section.lessons.find_by(name: 'Hash Class').lesson_sections.first.day_of_week).to eq 'monday'
  end
end
