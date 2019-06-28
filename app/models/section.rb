class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  acts_as_paranoid

  default_scope -> { order :number }

  before_validation :set_number, on: :create

  validates :name, :presence => true, uniqueness: { scope: :course }
  validates :number, :presence => true
  validates :course, :presence => true
  validate :name_does_not_conflict_with_routes
  validates :github_path, uniqueness: true, allow_blank: true

  has_many :lesson_sections, inverse_of: :section
  has_many :lessons, through: :lesson_sections
  belongs_to :course

  after_create :build_section, if: ->(section) { section.github_path.present? }
  after_update :build_section, if: ->(section) { section.github_path.present? && section.saved_change_to_github_path? }
  before_destroy :remove_github_path

  def empty_section!
    lesson_sections.each do |lesson_section|
      lesson = lesson_section.lesson
      lesson_section.really_destroy!
      lesson.really_destroy! if lesson.sections.empty?
    end
  end

  def build_section
    begin
      lessons_params = GithubReader.new(github_path).parse_layout_file
    rescue GithubError => e
      errors.add(:base, e.message)
      raise ActiveRecord::RecordInvalid, self
    end
    empty_section!
    lessons_params.each do |day_params|
      day_params[:lessons].each do |lesson_params|
        lesson = Lesson.create(name: lesson_params[:title], content: lesson_params[:content], cheat_sheet: lesson_params[:cheat_sheet], teacher_notes: lesson_params[:teacher_notes], public: true)
        lesson_sections.create(day_of_week: day_params[:day], work_type: lesson_params[:work_type], lesson: lesson)
      end
    end
  end

  def deep_clone(course_to_assign_to)
    new_section = self.dup
    new_section.course = course_to_assign_to
    new_section.save
    lesson_sections.each do |lesson_section|
      new_lesson_section = lesson_section.dup
      new_lesson_section.section = new_section
      new_lesson_section.save
    end
    new_section
  end

  def detach_lessons
    lesson_sections.each do |ls|
      new_lesson = ls.lesson.dup
      new_lesson.github_path = nil
      new_lesson.save
      ls.lesson = new_lesson
      ls.save
    end
  end

private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def set_number
    self.number = course.try(:sections).try(:last).try(:number).to_i + 1
  end

  def name_does_not_conflict_with_routes
    conflicting_names = ['sections', 'lessons', 'courses', 'tracks']
    if conflicting_names.include?(name.try(:downcase))
      errors.add(:name, "cannot be #{name}")
      false
    end
  end

  def remove_github_path
    update(github_path: nil)
  end
end
