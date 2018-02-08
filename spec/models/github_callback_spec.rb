describe GithubCallback do
  it 'returns true if event is push to master branch' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master' })
    expect(github_callback.push_to_master?).to be true
  end

  # disabled until can store GITHUB_APP_PEM in correct format on Travis (works locally & on Heroku)
  xit 'updates lesson content based on Github repo name & list of file paths', vcr: true do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['README.md'], 'added' => [], 'removed' => [] ] })
    github_callback.update_lessons
    expect(lesson.reload.content).to include 'testing'
  end

  # disabled until can store GITHUB_APP_PEM in correct format on Travis (works locally & on Heroku)
  xit 'marks lesson as private when removed from Github repo', vcr: true do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'removed' => ['README.md'] ] })
    github_callback.update_lessons
    expect(lesson.reload.public).to be false
  end
end
