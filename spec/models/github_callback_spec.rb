describe GithubCallback do
  it 'returns true if event is push to master branch' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master' })
    expect(github_callback.push_to_master?).to be true
  end

  it 'calls update_lessons with repo and list of files modified' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['MODIFIED.txt'], 'added' => ['ADDED.txt'], 'removed' => [] ] })
    expect(github_callback).to receive(:update_lessons).with({ repo: 'testing', modified: ['ADDED.txt', 'MODIFIED.txt'], removed: [] })
    github_callback.update_all
  end

  it 'calls update_sections with modified and added layout files only' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/MODIFIED.txt', 'example/layout.yaml'], 'added' => ['example/ADDED.txt', 'example/layout2.yaml'], 'removed' => ['ignore/layout.yaml'] ] })
    expect(github_callback).to receive(:update_sections).with({ repo: 'testing', paths: ['example/layout2.yaml', 'example/layout.yaml'] })
    github_callback.update_all
  end

  describe '#update_sections' do
    it 'updates section if a section has matching github path' do
      section = FactoryBot.create(:section, layout_file_path: nil)
      expect_any_instance_of(Section).to receive(:build_section)
      section.update(layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/layout.yaml")
    end

    it 'raises error when updating sections if invalid layout file' do
      section = FactoryBot.create(:section)
      path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/layout.yaml"
      section.update_columns(layout_file_path: path)
      layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with(filename:'layout.yaml').and_return(layout_file_response)
      expect { GithubCallback.new({}).update_sections({ repo: 'testing', paths: ['example/layout.yaml'] }) }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: Invalid layout file")
    end
  end

  describe '#update_lessons' do
    it 'updates lesson content based on Github repo name & list of file paths' do
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      GithubCallback.new({}).update_lessons({ repo: 'testing', modified: ['example/README.md'], removed: [] })
      expect(lesson.reload.content).to include 'test'
    end

    it 'marks lesson as private when removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      GithubCallback.new({}).update_lessons({ repo: 'testing', modified: [], removed: ['example/README.md'] })
      expect(lesson.reload.public).to be false
    end
  end
end
