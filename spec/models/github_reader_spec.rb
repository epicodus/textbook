describe GithubReader, vcr: true do
  it 'returns error for invalid layout_file_path' do
    expect { GithubReader.new('example.com') }.to raise_error(GithubError).with_message("Invalid layout file path example.com")
  end

  context 'creating and updating sections' do
    it 'parses layout file' do
      layout_file_response = File.read('spec/fixtures/layout.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with('layout.yaml').and_return(layout_file_response)
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Example Title", :filename=>"README.md", :work_type=>"lesson", :content=>"test", :cheat_sheet=>"test", :teacher_notes=>"test"}]}]
    end

    it 'pulls a layout file from github' do
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Example Title", :filename=>"README.md", :work_type=>"lesson", :content=>"example content\n", :cheat_sheet=>nil, :teacher_notes=>nil}]}]
    end

    it 'returns error for invalid layout file' do
      layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with('layout.yaml').and_return(layout_file_response)
      path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/static_for_automated_testing/layout.yaml"
      github_reader = GithubReader.new(path)
      expect { github_reader.parse_layout_file }.to raise_error(GithubError).with_message("Invalid layout file #{path}")
    end

    describe '#update_sections' do
      it 'updates section if a section has this github path' do
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
        allow_any_instance_of(GithubReader).to receive(:read_file).with('layout.yaml').and_return(layout_file_response)
        expect { GithubReader.update_sections({ repo: 'testing', directories: ['example'] }) }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: Invalid layout file #{path}")
      end
    end
  end
end
