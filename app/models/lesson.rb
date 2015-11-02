class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  acts_as_paranoid

  attr_accessor :number

  validates :name, :presence => true, :uniqueness => true
  validates :content, :presence => true
  validates :sections, presence: true
  validate :lesson_has_number

  has_many :lesson_sections
  has_many :sections, through: :lesson_sections

  before_destroy :set_private

  def section=(new_section)
    if new_section.nil?
      # do nothing
    elsif new_section.class == Section
      sections.push(new_section)
    else
      sections.push(Section.find(new_section))
    end
  end

  def section_id=(new_section)
    sections.push(Section.find(new_section))
  end

  def navigate_to(position, current_section)
    lesson_number = LessonSection.find_by(section_id: current_section.try(:id), lesson_id: id).try(:number)
    current_section_lessons = LessonSection.where(deleted_at: nil).where(section_id: current_section.try(:id))
    if position == :next
      next_lesson = current_section_lessons.where('number > ?', lesson_number).first
      Lesson.find(next_lesson.lesson_id) unless next_lesson.nil?
    elsif position == :previous
      previous_lesson = current_section_lessons.where('number < ?', lesson_number).last
      Lesson.find(previous_lesson.lesson_id) unless previous_lesson.nil?
    end
  end

  def can_navigate_to(position, current_section)
    self.navigate_to(position, current_section) != nil
  end

  def has_video?
    !video_id.blank?
  end

  def has_cheat_sheet?
    !cheat_sheet.blank?
  end

  def has_update_warning?
    !update_warning.blank?
  end

private

  def lesson_has_number
    unless number.present? && !number.is_a?(Float) && number.to_i.is_a?(Integer) && number.to_i > 0
      errors.add(:number, "cannot be blank")
      false
    end
  end

  def set_private
    update(:public => false)
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
