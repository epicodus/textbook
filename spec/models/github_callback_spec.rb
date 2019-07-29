describe GithubCallback do
  it 'returns true if event is push to master branch' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master' })
    expect(github_callback.push_to_master?).to be true
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
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/layout.yaml'], 'added' => [], 'removed' => [] ] })
      expect { github_callback.update_sections }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: Invalid layout file")
    end
  end

  describe '#update_lessons' do
    it 'updates lesson content based on Github repo name & list of file paths' do
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README.md'], 'added' => [], 'removed' => [] ] })
      github_callback.update_lessons
      expect(lesson.reload.content).to include 'test'
    end

    it 'updates lesson when that lesson cheat sheet or teacher notes updated on Github' do
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('updated')
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README_teacher.md'], 'added' => [], 'removed' => [] ] })
      github_callback.update_lessons
      expect(lesson.reload.content).to include 'updated'
    end

    it 'marks lesson as private when removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/README.md'] ] })
      github_callback.update_lessons
      expect(lesson.reload.public).to be false
    end
  end
end
