class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  acts_as_paranoid

  default_scope -> { order :number }

  validates :name, :presence => true, :uniqueness => true
  validates :content, :presence => true
  validates :number, :presence => true, :numericality => { :only_integer => true }
  # validates :section, :presence => true

  has_many :lesson_sections
  has_many :sections, through: :lesson_sections

  before_destroy :set_private

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

  def set_private
    update(:public => false)
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
