require 'spec_helper'

describe Lesson do
  it { should validate_presence_of :content }
  it { should validate_presence_of :name }
  it { should validate_presence_of :sections }
  it { should have_many(:sections).through(:lesson_sections) }

  it "validates that a lesson is created with a number" do
    lesson = FactoryGirl.build(:lesson, number: nil)
    expect(lesson.valid?).to be false
  end

  it "validates that a lesson is created with a number that is an integer" do
    lesson = FactoryGirl.build(:lesson, number: 100.77)
    expect(lesson.valid?).to be false
  end

  it "validates that a lesson is created with a number that is a positive integer" do
    lesson = FactoryGirl.build(:lesson, number: -44)
    expect(lesson.valid?).to be false
  end

  it 'validates uniqueness of name' do
    FactoryGirl.create :lesson
    should validate_uniqueness_of :name
  end

  it 'changes the slug on update' do
    lesson = FactoryGirl.create :lesson
    lesson.update(:name => 'New name')
    lesson.slug.should eq 'new-name'
  end

  context 'navigate to next lesson' do
    let!(:section) { FactoryGirl.create(:section) }
    let!(:current_lesson) { FactoryGirl.create(:lesson, number: 1, section: section) }

    before { LessonSection.first.update(number: current_lesson.number) }

    it 'returns the lesson with the next-highest number than the current lesson' do
      next_lesson = FactoryGirl.create :lesson, number: 2, section: section
      LessonSection.last.update(number: next_lesson.number)
      current_lesson.navigate_to(:next, section).should eq next_lesson
    end

    it 'returns nil when there is only one lesson in a section' do
      current_lesson.navigate_to(:next, section).should eq nil
    end
  end

  context 'navigate to previous lesson' do
    let!(:section) { FactoryGirl.create(:section) }
    let!(:current_lesson) { FactoryGirl.create(:lesson, number: 2, section: section) }

    it 'returns the lesson with the next-lowest number than the current lesson' do
      previous_lesson = FactoryGirl.create :lesson, :number => 1, section: section
      current_lesson.navigate_to(:previous, section).should eq previous_lesson
    end

    it 'returns nil when there is only one lesson in a section' do
      current_lesson.navigate_to(:previous, section).should eq nil
    end
  end

  context 'next navigation lesson exists' do
    let!(:section) { FactoryGirl.create(:section) }

    it 'returns false if there is no next lesson' do
      current_lesson = FactoryGirl.create :lesson, section: section
      current_lesson.can_navigate_to(:next, section).should be false
    end

    it 'returns true if there is a next lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 1, section: section
      next_lesson = FactoryGirl.create :lesson, :number => 2, section: section
      current_lesson.can_navigate_to(:next, section).should be true
    end
  end

  context 'previous navigating lesson exists' do
    let!(:section) { FactoryGirl.create(:section) }

    it 'returns false if there is no previous lesson' do
      current_lesson = FactoryGirl.create :lesson, section: section
      current_lesson.can_navigate_to(:previous, section).should be false
    end

    it 'returns true if there is a previous lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 2, section: section
      previous_lesson = FactoryGirl.create :lesson, :number => 1, section: section
      current_lesson.can_navigate_to(:previous, section).should be true
    end
  end

  context '#has_video?' do
    it 'returns false if there is no video id' do
      lesson = FactoryGirl.create :lesson, :video_id => nil
      lesson.has_video?.should be false
    end

    it 'returns true if there is a video id' do
      lesson = FactoryGirl.create :lesson
      lesson.has_video?.should be true
    end
  end

  context '#has_cheat_sheet?' do
    it 'returns false if there is no cheat sheet' do
      lesson = FactoryGirl.create :lesson, :cheat_sheet => nil
      lesson.has_cheat_sheet?.should be false
    end

    it 'returns true if there is a cheat sheet' do
      lesson = FactoryGirl.create :lesson
      lesson.has_cheat_sheet?.should be true
    end
  end

  context '#has_update_warning?' do
    it 'returns false if there is no update warning' do
      lesson = FactoryGirl.create :lesson, :update_warning => nil
      lesson.has_update_warning?.should be false
    end

    it 'returns true if there is a update warning' do
      lesson = FactoryGirl.create :lesson
      lesson.has_update_warning?.should be true
    end
  end

  context 'callbacks' do
    it 'sets public to false before deleting' do
      lesson = FactoryGirl.create :lesson
      lesson.destroy
      lesson.reload
      lesson.should_not be_public
    end
  end
end
