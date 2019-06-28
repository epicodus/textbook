class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  acts_as_paranoid

  validates :name, :presence => true
  validates :content, :presence => true

  has_many :lesson_sections, inverse_of: :lesson, dependent: :destroy
  has_many :sections, through: :lesson_sections

  before_validation :update_from_github, if: ->(lesson) { lesson.github_path.present? }
  before_destroy :set_private, unless: ->(lesson) { lesson.deleted? }
  after_destroy :remove_slug, if: ->(lesson) { Lesson.only_deleted.exists?(lesson.id) }
  after_restore :create_slug

  accepts_nested_attributes_for :lesson_sections

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

  def set_private
    update(:public => false)
  end

  def create_slug
    save
  end

  def remove_slug
    update(slug: nil)
  end

  def should_generate_new_friendly_id?
    name_changed? || (slug.blank? && !deleted?)
  end

  def update_from_github
    response = Github.get_content(github_path)
    if response[:error]
      errors.add(:base, 'Unable to pull lesson from Github')
      throw(:abort)
    else
      self.content = response[:content]
    end
  end
end
