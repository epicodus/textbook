describe Github do
  # disabled until can store GITHUB_APP_PEM in correct format on Travis (works locally & on Heroku)
  xit 'updates lesson content based on Github repo name & list of file paths', vcr: true do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: ['README.md'], removed: [] })
    expect(lesson.reload.content).to include 'testing'
  end

  # disabled until can store GITHUB_APP_PEM in correct format on Travis (works locally & on Heroku)
  xit 'marks lesson as private when removed from Github repo', vcr: true do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: [], removed: ['README.md'] })
    expect(lesson.reload.public).to be false
  end
end
