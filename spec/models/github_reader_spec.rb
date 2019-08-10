describe GithubReader, vcr: true do
  it 'raises error for invalid layout_file_path' do
    expect { GithubReader.new('example.com') }.to raise_error(GithubError).with_message("Invalid Github path")
  end

  context 'creating sections' do
    it 'parses layout file' do
      layout_file_response = File.read('spec/fixtures/layout.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with(filename:'layout.yaml').and_return(layout_file_response)
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Example Title", :filename=>"README.md", :work_type=>"lesson", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/README.md"}]}]
    end

    it 'parses layout file with nested directories' do
      layout_file_response = File.read('spec/fixtures/layout_nested.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with(filename:'layout.yaml').and_return(layout_file_response)
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Nested Lesson", :filename=>"README.md", :work_type=>"lesson", :directory=>"static_for_automated_testing/subdir", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/subdir/README.md"}]}]
    end

    it 'parses layout file with lessons linking to other repos' do
      layout_file_response = File.read('spec/fixtures/layout_shared_lessons.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with(filename:'layout.yaml').and_return(layout_file_response)
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Shared Lesson", :filename=>"shared.md", :work_type=>"lesson", :repo=>"shared_repo", :directory=>"static_for_automated_testing", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/shared_repo/blob/master/static_for_automated_testing/shared.md"}]}]
    end

    it 'parses layout file with root level directories' do
      layout_file_response = File.read('spec/fixtures/layout_shared_lessons_root_level.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with(filename:'layout.yaml').and_return(layout_file_response)
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Shared Lesson", :filename=>"shared.md", :work_type=>"lesson", :repo=>"shared_repo", :directory=>"/", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/shared_repo/blob/master/shared.md"}]}]
    end

    it 'pulls a layout file from github' do
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Example Title", :filename=>"README.md", :work_type=>"lesson", :github_path=>"https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/README.md"}]}]
    end

    it 'raises error for invalid layout file' do
      layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with(filename:'layout.yaml').and_return(layout_file_response)
      path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml"
      github_reader = GithubReader.new(path)
      expect { github_reader.parse_layout_file }.to raise_error(GithubError).with_message("Invalid layout file")
    end
  end

  context 'pulling lesson' do
    it 'pulls content from Github' do
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      lesson_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/README.md").pull_lesson
      expect(lesson_params[:content]).to eq 'test'
      expect(lesson_params[:teacher_notes]).to eq 'test'
      expect(lesson_params[:cheat_sheet]).to eq 'test'
    end
  end
end
