require 'spec_helper'

describe Lesson do
  it { should validate_presence_of :name }
  it { should validate_presence_of :content }
  it { should validate_presence_of :number }
  it { should validate_numericality_of(:number).only_integer }

  it "validates that a lesson is created with a section" do
    lesson = FactoryGirl.build(:lesson, section: nil)
    expect(lesson.valid?).to be false
  end

  it 'validates uniqueness of name' do
    FactoryGirl.create :lesson
    should validate_uniqueness_of :name
  end

  it { should have_many(:sections).through(:lesson_sections) }

  it 'sorts by the number by default' do
    last_lesson = FactoryGirl.create :lesson, :number => 4
    (2..3).each {|number| FactoryGirl.create :lesson, :number => number}
    first_lesson = FactoryGirl.create :lesson, :number => 1
    Lesson.first.should eq first_lesson
    Lesson.last.should eq last_lesson
  end

  it 'changes the slug on update' do
    lesson = FactoryGirl.create :lesson
    lesson.update(:name => 'New name')
    lesson.slug.should eq 'new-name'
  end

  context '#next' do
    it 'returns the lesson with the next-highest number than the current lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 1
      next_lesson = FactoryGirl.create :lesson, :number => 2
      current_lesson.next.should eq next_lesson
    end
  end

  context '#previous' do
    it 'returns the lesson with the next-lowest number than the current lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 2
      previous_lesson = FactoryGirl.create :lesson, :number => 1
      current_lesson.previous.should eq previous_lesson
    end
  end

  context '#next_lesson?' do
    it 'returns false if there is no next lesson' do
      current_lesson = FactoryGirl.create :lesson
      current_lesson.next_lesson?.should be false
    end

    it 'returns true if there is a next lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 1
      next_lesson = FactoryGirl.create :lesson, :number => 2
      current_lesson.next_lesson?.should be true
    end
  end

  context '#previous_lesson?' do
    it 'returns false if there is no previous lesson' do
      current_lesson = FactoryGirl.create :lesson
      current_lesson.previous_lesson?.should be false
    end

    it 'returns true if there is a previous lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 2
      previous_lesson = FactoryGirl.create :lesson, :number => 1
      current_lesson.previous_lesson?.should be true
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
