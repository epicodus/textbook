class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  attr_accessor :number

  acts_as_paranoid

  default_scope -> { order :number }

  validates :name, :presence => true, :uniqueness => true
  validates :content, :presence => true
  validates :number, :presence => true, :numericality => { :only_integer => true }
  validate :lesson_has_section

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

  def next
    Lesson.where('number > ?', number).first
  end

  def previous
    Lesson.where('number < ?', number).last
  end

  def next_lesson?
    self.next != nil
  end

  def previous_lesson?
    self.previous != nil
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

  def lesson_has_section
    unless sections.present?
      errors.add(:section, "cannot be blank")
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
