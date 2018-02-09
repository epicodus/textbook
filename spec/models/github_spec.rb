describe Github do
  it 'updates lesson content based on Github repo name & list of file paths', vcr: true do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: ['README.md'], removed: [] })
    expect(lesson.reload.content).to include 'testing'
  end

  it 'marks lesson as private when removed from Github repo', vcr: true do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: [], removed: ['README.md'] })
    expect(lesson.reload.public).to be false
  end

  it 'fetches lesson content from Github given github_path', vcr: true do
    github_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md"
    expect(Github.get_content(github_path)[:content]).to include 'testing'
  end
end
