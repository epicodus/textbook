describe Lesson do
  it { should validate_presence_of :content }
  it { should validate_presence_of :name }
  it { should have_many(:sections).through(:lesson_sections) }

  it 'changes the slug on update' do
    lesson = FactoryBot.create :lesson
    lesson.update(:name => 'New name')
    expect(lesson.slug).to eq 'new-name'
  end

  context 'navigate to next lesson' do
    let!(:section) { FactoryBot.create(:section) }
    let!(:current_lesson) { FactoryBot.create(:lesson, section: section) }

    it 'returns the lesson with the next-highest number than the current lesson' do
      next_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.navigate_to(:next, section)).to eq next_lesson
    end

    it 'returns nil when there is only one lesson in a section' do
      expect(current_lesson.navigate_to(:next, section)).to eq nil
    end
  end

  context 'navigate to previous lesson' do
    let!(:section) { FactoryBot.create(:section) }
    let!(:previous_lesson) { FactoryBot.create(:lesson, section: section) }
    let!(:current_lesson) { FactoryBot.create(:lesson, section: section) }
    let!(:next_lesson) { FactoryBot.create(:lesson, section: section) }

    it 'returns the lesson with the next-lowest number than the current lesson' do
      expect(current_lesson.navigate_to(:previous, section)).to eq previous_lesson
    end

    it 'returns nil when there is only one lesson in a section' do
      new_section = FactoryBot.create(:section)
      solo_lesson = FactoryBot.create(:lesson, section: new_section)
      expect(solo_lesson.navigate_to(:previous, section)).to eq nil
    end
  end

  context 'next navigation lesson exists' do
    let!(:section) { FactoryBot.create(:section) }

    it 'returns false if there is no next lesson' do
      current_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:next, section)).to be false
    end

    it 'returns true if there is a next lesson' do
      current_lesson = FactoryBot.create :lesson, section: section
      next_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:next, section)).to be true
    end
  end

  context 'previous navigating lesson exists' do
    let!(:section) { FactoryBot.create(:section) }

    it 'returns false if there is no previous lesson' do
      current_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:previous, section)).to be false
    end

    it 'returns true if there is a previous lesson' do
      previous_lesson = FactoryBot.create :lesson, section: section
      current_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:previous, section)).to be true
    end
  end

  it 'updates the slug when a lesson name is updated' do
    lesson = FactoryBot.create(:lesson)
    lesson.update(name: 'New awesome lesson')
    expect(lesson.slug).to eq 'new-awesome-lesson'
  end

  context '#has_video?' do
    it 'returns false if there is no video id' do
      lesson = FactoryBot.create :lesson, :video_id => nil
      expect(lesson.has_video?).to be false
    end

    it 'returns true if there is a video id' do
      lesson = FactoryBot.create :lesson
      expect(lesson.has_video?).to be true
    end
  end

  context '#has_cheat_sheet?' do
    it 'returns false if there is no cheat sheet' do
      lesson = FactoryBot.create :lesson, :cheat_sheet => nil
      expect(lesson.has_cheat_sheet?).to be false
    end

    it 'returns true if there is a cheat sheet' do
      lesson = FactoryBot.create :lesson
      expect(lesson.has_cheat_sheet?).to be true
    end
  end

  context '#has_update_warning?' do
    it 'returns false if there is no update warning' do
      lesson = FactoryBot.create :lesson, :update_warning => nil
      expect(lesson.has_update_warning?).to be false
    end

    it 'returns true if there is a update warning' do
      lesson = FactoryBot.create :lesson
      expect(lesson.has_update_warning?).to be true
    end
  end

  context 'callbacks' do
    it 'sets public to false before deleting' do
      lesson = FactoryBot.create :lesson
      lesson.destroy
      lesson.reload
      expect(lesson).to_not be_public
    end

    it 'removes slug after deleting' do
      lesson = FactoryBot.create :lesson
      lesson.destroy
      lesson.reload
      expect(lesson.slug).to eq nil
    end

    it 'creates slug when lesson restored' do
      lesson = FactoryBot.create :lesson
      lesson.destroy
      lesson.restore
      lesson.reload
      expect(lesson.slug).to_not eq nil
    end

    describe 'pulling from Github' do
      it 'tries to update lesson from github when github_path present' do
        allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({})
        lesson = FactoryBot.build(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
        expect_any_instance_of(GithubReader).to receive(:pull_lesson)
        lesson.save
      end

      it 'saves when lesson successfully fetched from github' do
        allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({content: 'new lesson content'})
        lesson = FactoryBot.build(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
        expect(lesson.save).to eq true
      end

      it 'retrieves content and cheat sheet and teacher notes' do
        allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({ content: 'new lesson content', cheat_sheet: 'test cheat sheet', teacher_notes: 'test teacher notes' })
        lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
        expect(lesson.content).to eq 'new lesson content'
        expect(lesson.cheat_sheet).to eq 'test cheat sheet'
        expect(lesson.teacher_notes).to eq 'test teacher notes'
      end

      it 'does not save when problem fetching lesson from github' do
        allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({})
        lesson = FactoryBot.build(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
        expect(lesson.save).to eq false
      end
    end
  end

  context 'setter methods' do
    it 'adds a section for the lesson with section_id=' do
      section = FactoryBot.create(:section)
      section_2 = FactoryBot.create(:section)
      lesson = FactoryBot.create(:lesson, section: section)
      lesson.section_id=(section_2.id)
      expect(lesson.sections).to eq [section, section_2]
    end

    it 'adds a section for the lesson with section=' do
      section = FactoryBot.create(:section)
      section_2 = FactoryBot.create(:section)
      lesson = FactoryBot.create(:lesson, section: section)
      lesson.section=(section_2.id)
      expect(lesson.sections).to eq [section, section_2]
    end
  end

  context 'paranoia' do
    it 'archives destroyed lesson' do
      lesson = FactoryBot.create(:lesson)
      lesson.destroy
      expect(Lesson.count).to eq 0
      expect(Lesson.with_deleted.count).to eq 1
    end

    it 'restores archived lesson' do
      lesson = FactoryBot.create(:lesson)
      lesson.destroy
      lesson.restore
      expect(Lesson.count).to eq 1
    end
  end
end
