describe GithubCallback do
  it 'returns true if event is push to master branch' do
    github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master' })
    expect(github_callback.push_to_master?).to be true
  end

  describe '#update_sections' do
    it 'is ignored if no matching layout file path' do
      section = FactoryBot.create(:section)
      section.update_columns(layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/does_not_exist/layout.yaml")
      webhook_params = JSON.parse(File.read('spec/fixtures/fake_github_webhook_update_section_layout.json'))['body']
      github_callback = GithubCallback.new(webhook_params)
      expect_any_instance_of(Section).to_not receive(:build_section)
      github_callback.update_sections
    end

    it 'updates section if a section has matching layout file path' do
      section = FactoryBot.create(:section)
      section.update_columns(layout_file_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/layout.yaml")
      webhook_params = JSON.parse(File.read('spec/fixtures/fake_github_webhook_update_section_layout.json'))['body']
      github_callback = GithubCallback.new(webhook_params)
      expect_any_instance_of(Section).to receive(:build_section)
      github_callback.update_sections
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
    it 'updates lesson when lesson updated on Github' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'updated')
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README.md'], 'added' => [], 'removed' => [] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'updated'
    end

    it 'updates lesson when cheat sheet updated on Github' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'updated', teacher_notes: 'test')
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README_cheat.md'], 'added' => [], 'removed' => [] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'test'
      expect(lesson.cheat_sheet).to eq 'updated'
      expect(lesson.teacher_notes).to eq 'test'
    end

    it 'updates lesson when teacher notes updated on Github' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'updated')
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README_teacher.md'], 'added' => [], 'removed' => [] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'test'
      expect(lesson.cheat_sheet).to eq 'test'
      expect(lesson.teacher_notes).to eq 'updated'
    end

    it 'updates lesson when removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/README.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'Removed from Github'
      expect(lesson.cheat_sheet).to eq nil
      expect(lesson.teacher_notes).to eq nil
    end

    it 'updates lesson when cheat sheet removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: nil, teacher_notes: 'test')
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/README_cheat.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'test'
      expect(lesson.cheat_sheet).to eq nil
      expect(lesson.teacher_notes).to eq 'test'
    end

    it 'updates lesson when teacher notes removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: nil)
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/README_teacher.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'test'
      expect(lesson.cheat_sheet).to eq 'test'
      expect(lesson.teacher_notes).to eq nil
    end

    it 'updates lesson when both lesson and teacher notes removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/README.md', 'example/README_teacher.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'Removed from Github'
      expect(lesson.cheat_sheet).to eq nil
      expect(lesson.teacher_notes).to eq nil
    end

    it 'updates lesson when both lesson and cheat sheet removed from Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/README.md', 'example/README_cheat.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'Removed from Github'
      expect(lesson.cheat_sheet).to eq nil
      expect(lesson.teacher_notes).to eq nil
    end

    it 'updates lesson when lesson removed and teacher notes modified on Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README_teacher.md'], 'added' => [], 'removed' => ['example/README.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'Removed from Github'
      expect(lesson.cheat_sheet).to eq nil
      expect(lesson.teacher_notes).to eq nil
    end

    it 'updates lesson when lesson removed and cheat sheet modified on Github repo' do
      allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return(content: 'test', cheat_sheet: 'test', teacher_notes: 'test')
      lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/example/README.md")
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/README_cheat.md'], 'added' => [], 'removed' => ['example/README.md'] ] })
      github_callback.update_lessons
      lesson.reload
      expect(lesson.content).to eq 'Removed from Github'
      expect(lesson.cheat_sheet).to eq nil
      expect(lesson.teacher_notes).to eq nil
    end

    it 'does not try to update lesson when layout file modified' do
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => ['example/layout.yaml'], 'added' => [], 'removed' => [] ] })
      expect_any_instance_of(GithubReader).to_not receive(:pull_lesson)
      github_callback.update_lessons
    end

    it 'does not try to update lesson when layout file deleted' do
      github_callback = GithubCallback.new({ 'ref' => 'refs/heads/master', 'repository' => { 'name' => 'testing' }, 'commits' => [ 'modified' => [], 'added' => [], 'removed' => ['example/layout.yaml'] ] })
      expect_any_instance_of(GithubReader).to_not receive(:pull_lesson)
      github_callback.update_lessons
    end
  end
end
