describe GithubReader, vcr: true do
  it 'returns error for invalid github_path' do
    expect { GithubReader.new('example.com') }.to raise_error(GithubError).with_message("Invalid github path example.com")
  end

  context 'creating and updating sections' do
    it 'parses layout file' do
      layout_file_response = File.read('spec/fixtures/layout.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with('layout.yaml').and_return(layout_file_response)
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/static_for_automated_testing").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Example Title", :filename=>"README.md", :work_type=>"lesson", :content=>"test", :cheat_sheet=>"test", :teacher_notes=>"test"}]}]
    end

    it 'pulls a layout file from github' do
      lessons_params = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/static_for_automated_testing").parse_layout_file
      expect(lessons_params).to eq [{:day=>"monday", :lessons=>[{:title=>"Example Title", :filename=>"README.md", :work_type=>"lesson", :content=>"example content\n", :cheat_sheet=>nil, :teacher_notes=>nil}]}]
    end

    it 'returns error for invalid layout file' do
      layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.yaml')
      allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
      allow_any_instance_of(GithubReader).to receive(:read_file).with('layout.yaml').and_return(layout_file_response)
      github_reader = GithubReader.new("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/static_for_automated_testing")
      expect { github_reader.parse_layout_file }.to raise_error(GithubError).with_message("Invalid layout file for testing/static_for_automated_testing")
    end

    describe '#update_sections' do
      it 'updates section if a section has this github path' do
        section = FactoryBot.create(:section, github_path: nil)
        expect_any_instance_of(Section).to receive(:build_section)
        section.update(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/example")
      end

      it 'raises error when updating sections if invalid layout file' do
        section = FactoryBot.create(:section)
        section.update_columns(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/example")
        layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.yaml')
        allow_any_instance_of(GithubReader).to receive(:read_file).and_return('test')
        allow_any_instance_of(GithubReader).to receive(:read_file).with('layout.yaml').and_return(layout_file_response)
        expect { GithubReader.update_sections({ repo: 'testing', directories: ['example'] }) }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: Invalid layout file for testing/example")
      end
    end
  end
end
