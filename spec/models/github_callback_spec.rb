describe GithubCallback do
  it 'returns true if event is push to master branch' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master' })
    expect(github_callback.push_to_master?).to be true
  end

  it 'calls Github.update_lessons with repo and list of files modified' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['MODIFIED.txt'], 'added' => ['ADDED.txt'], 'removed' => [] ] })
    expect(Github).to receive(:update_lessons).with({ repo: 'testing', modified: ['ADDED.txt', 'MODIFIED.txt'], removed: [] })
    github_callback.update_lessons
  end

  it 'calls GithubReader.update_sections with repo and list of files modified' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/MODIFIED.txt'], 'added' => ['example/ADDED.txt'], 'removed' => [] ] })
    expect(GithubReader).to receive(:update_sections).with({ repo: 'testing', directories: ['example'] })
    github_callback.update_lessons
  end

  it 'calls GithubReader.update_sections with repo and list of files removed' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/REMOVED.txt'] ] })
    expect(GithubReader).to receive(:update_sections).with({ repo: 'testing', directories: ['example'] })
    github_callback.update_lessons
  end
end
