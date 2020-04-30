class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders, :scoped], :scope => :section

  default_scope -> { order :number }

  belongs_to :section

  validates :name, :presence => true
  validates :content, :presence => true
  validates :number, presence: true, numericality: { only_integer: true }

  before_validation :set_number, on: :create
  before_validation :set_placeholder_content, if: ->(lesson) { lesson.github_path.present? }

  after_save :update_from_github, if: ->(lesson) { lesson.github_path.present? }
  enum work_type: [ :lesson, :exercise ]
  enum day_of_week: [ :weekend, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday ]

  def navigate_to(position)
    if position == :next
      section.lessons.where('number > ?', number).first
    elsif position == :previous
      section.lessons.where('number < ?', number).last
    end
  end

  def can_navigate_to(position)
    self.navigate_to(position) != nil
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

  def set_number
    self.number = section.try(:lessons).try(:last).try(:number).to_i + 1
  end
end
