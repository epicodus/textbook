require 'spec_helper'

describe Lesson do
  it {should allow_mass_assignment_of :name}
  it {should allow_mass_assignment_of :content}
  it {should allow_mass_assignment_of :section_id}
  it {should allow_mass_assignment_of :number}

  it {should validate_presence_of :name}
  it {should validate_presence_of :content}
  it {should validate_presence_of :section}
  it {should validate_presence_of :number}
  it {should validate_numericality_of(:number).only_integer}

  it {should belong_to :section}

  it 'sorts by the number by default' do
    last_lesson = FactoryGirl.create :lesson, :number => 9
    (2..8).each {|number| FactoryGirl.create :lesson, :number => number}
    first_lesson = FactoryGirl.create :lesson, :number => 1
    Lesson.first.should eq first_lesson
    Lesson.last.should eq last_lesson
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
      current_lesson.next_lesson?.should be_false
    end

    it 'returns true if there is a next lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 1
      next_lesson = FactoryGirl.create :lesson, :number => 2
      current_lesson.next_lesson?.should be_true
    end
  end

  context '#previous_lesson?' do
    it 'returns false if there is no previous lesson' do
      current_lesson = FactoryGirl.create :lesson
      current_lesson.previous_lesson?.should be_false
    end

    it 'returns true if there is a previous lesson' do
      current_lesson = FactoryGirl.create :lesson, :number => 2
      previous_lesson = FactoryGirl.create :lesson, :number => 1
      current_lesson.previous_lesson?.should be_true
    end
  end
end
