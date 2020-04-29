class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  validates :name, :presence => true
  validates :content, :presence => true

  has_many :lesson_sections, inverse_of: :lesson, dependent: :destroy
  has_many :sections, through: :lesson_sections

  before_validation :set_placeholder_content, if: ->(lesson) { lesson.github_path.present? }
  after_save :update_from_github, if: ->(lesson) { lesson.github_path.present? }

  accepts_nested_attributes_for :lesson_sections

  enum work_type: [ :lesson, :exercise ]
  enum day_of_week: [ :weekend, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday ]

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
    current_section_lessons = LessonSection.where(section_id: current_section.try(:id))
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

  def set_placeholder_content
    self.content = 'Lesson queued for update... hit refresh soon!'
  end

  def update_from_github
    GithubLessonReaderJob.perform_later(self)
  end

  def self.update_from_github(lesson)
    lesson_params = GithubReader.new(lesson.github_path).pull_lesson
    lesson.update_columns(content: lesson_params[:content], cheat_sheet: lesson_params[:cheat_sheet], teacher_notes: lesson_params[:teacher_notes], video_id: lesson_params[:video_id])
  end

private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
