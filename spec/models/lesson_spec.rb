describe Lesson do
  it { should belong_to :section }
  it { should validate_presence_of :content }
  it { should validate_presence_of :name }

  describe 'validations' do
    it 'validates that a lesson always has a number' do
      lesson = FactoryBot.create(:lesson)
      expect(lesson.update(number: nil)).to be false
    end

    it 'validates that a lesson always has a number that is an integer' do
      section = FactoryBot.create(:section)
      lesson = FactoryBot.create(:lesson)
      expect(lesson.update(number: 1.7)).to be false
    end
  end

  describe 'default scope' do
    let(:section) { FactoryBot.create(:section) }
    let(:last_lesson) { FactoryBot.create :lesson, section: section}
    let(:first_lesson) { FactoryBot.create :lesson, section: section }

    it 'sorts by the number by default' do
      first_lesson.update(number: 1)
      last_lesson.update(number: 2)
      expect(section.lessons.first).to eq first_lesson
      expect(section.lessons.last).to eq last_lesson
    end
  end

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
      expect(current_lesson.navigate_to(:next)).to eq next_lesson
    end

    it 'returns nil when there is only one lesson in a section' do
      expect(current_lesson.navigate_to(:next)).to eq nil
    end
  end

  context 'navigate to previous lesson' do
    let!(:section) { FactoryBot.create(:section) }
    let!(:previous_lesson) { FactoryBot.create(:lesson, section: section) }
    let!(:current_lesson) { FactoryBot.create(:lesson, section: section) }
    let!(:next_lesson) { FactoryBot.create(:lesson, section: section) }

    it 'returns the lesson with the next-lowest number than the current lesson' do
      expect(current_lesson.navigate_to(:previous)).to eq previous_lesson
    end

    it 'returns nil when there is only one lesson in a section' do
      new_section = FactoryBot.create(:section)
      solo_lesson = FactoryBot.create(:lesson, section: new_section)
      expect(solo_lesson.navigate_to(:previous)).to eq nil
    end
  end

  context 'next navigation lesson exists' do
    let!(:section) { FactoryBot.create(:section) }

    it 'returns false if there is no next lesson' do
      current_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:next)).to be false
    end

    it 'returns true if there is a next lesson' do
      current_lesson = FactoryBot.create :lesson, section: section
      next_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:next)).to be true
    end
  end

  context 'previous navigating lesson exists' do
    let!(:section) { FactoryBot.create(:section) }

    it 'returns false if there is no previous lesson' do
      current_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:previous)).to be false
    end

    it 'returns true if there is a previous lesson' do
      previous_lesson = FactoryBot.create :lesson, section: section
      current_lesson = FactoryBot.create :lesson, section: section
      expect(current_lesson.can_navigate_to(:previous)).to be true
    end
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

  context '#index' do
    it 'returns index of lesson in that section' do
      section = FactoryBot.create(:section)
      lesson_1 = FactoryBot.create(:lesson, section: section)
      lesson_2 = FactoryBot.create(:lesson, section: section)
      expect(lesson_2.index).to eq 1
    end
  end

  context 'callbacks' do
    describe 'pulling from Github' do
      it 'does not try to pull from github unless github_path present' do
        lesson = FactoryBot.build(:lesson)
        expect(lesson).to_not receive(:update_from_github)
        lesson.save
      end

      it 'tries to update lesson from github when github_path present' do
        allow(GithubLessonReaderJob).to receive(:perform_later).and_return({})
        lesson = FactoryBot.build(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/main/README.md")
        expect(GithubLessonReaderJob).to receive(:perform_later)
        lesson.save
      end

      it "updates lesson content" do
        lesson = FactoryBot.create(:lesson)
        lesson.update_columns(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/main/README.md")
        allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({:content=>"updated content", :cheat_sheet=>nil, :teacher_notes=>nil, :video_id=>nil})
        expect(lesson.content).to eq 'This is the lesson content.'
        Lesson.update_from_github(lesson)
        lesson.reload
        expect(lesson.content).to eq 'updated content'
        expect(lesson.cheat_sheet).to eq nil
        expect(lesson.teacher_notes).to eq nil
        expect(lesson.video_id).to eq nil
      end

      it "updates lesson content, cheat sheet, teacher notes, video id when present" do
        lesson = FactoryBot.create(:lesson)
        lesson.update_columns(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/main/README.md")
        allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({ content: 'new lesson content', cheat_sheet: 'test cheat sheet', teacher_notes: 'test teacher notes', video_id: 'test video id' })
        Lesson.update_from_github(lesson)
        lesson.reload
        expect(lesson.content).to eq 'new lesson content'
        expect(lesson.cheat_sheet).to eq 'test cheat sheet'
        expect(lesson.teacher_notes).to eq 'test teacher notes'
        expect(lesson.video_id).to eq 'test video id'
      end
    end
  end
end
