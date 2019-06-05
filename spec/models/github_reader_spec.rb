describe GithubReader, vcr: true do
  context 'creating and updating sections' do
    it 'parses layout file' do
      layout_file_response = File.read('spec/fixtures/layout.md')
      allow(GithubReader).to receive(:read_file).and_return('test')
      allow(GithubReader).to receive(:read_file).with(repo: 'testing', directory: 'static_for_automated_testing', filename: 'layout.md').and_return(layout_file_response)
      lessons_params = GithubReader.parse_layout_file("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/static_for_automated_testing")
      expect(lessons_params).to eq [{:day_of_week=>"monday", :work_type=>"lesson", :title=>"Example Title", :content=>'test', :cheat_sheet=>'test', :teacher_notes=>'test'}]
    end

    it 'pulls a layout file from github' do
      lessons_params = GithubReader.parse_layout_file("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/static_for_automated_testing")
      expect(lessons_params).to eq [{:day_of_week=>"monday", :work_type=>"lesson", :title=>"Example Title", :content=>"example content\n", :cheat_sheet=>nil, :teacher_notes=>nil}]
    end

    it 'returns error for invalid layout file' do
      layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.md')
      allow(GithubReader).to receive(:read_file).and_return('test')
      allow(GithubReader).to receive(:read_file).with(repo: 'testing', directory: 'static_for_automated_testing', filename: 'layout.md').and_return(layout_file_response)
      expect { GithubReader.parse_layout_file("https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/tree/master/static_for_automated_testing") }.to raise_error(GithubError).with_message("Unable to parse layout file for repo testing")
    end

    it 'returns error for invalid github_path' do
      expect { GithubReader.parse_layout_file('example.com') }.to raise_error(GithubError).with_message("Invalid github path example.com")
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
        layout_file_response = File.read('spec/fixtures/layout_missing_day_of_week.md')
        allow(GithubReader).to receive(:read_file).and_return('test')
        allow(GithubReader).to receive(:read_file).with(repo: 'testing', directory: 'example', filename: 'layout.md').and_return(layout_file_response)
        expect { GithubReader.update_sections({ repo: 'testing', directories: ['example'] }) }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: Unable to parse layout file for repo testing")
      end
    end
  end
end
