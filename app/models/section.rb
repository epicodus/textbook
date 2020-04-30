class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders, :scoped], :scope => :course

  default_scope -> { order :number }

  belongs_to :course
  has_many :lessons, :dependent => :destroy

  before_validation :set_number, on: :create

  validates :name, :presence => true
  validates :number, :presence => true
  validate :name_does_not_conflict_with_routes

  after_create :build_section, if: ->(section) { section.layout_file_path.present? }
  after_update :build_section, if: ->(section) { section.layout_file_path.present? }

  def build_section
    begin
      lessons_params = GithubReader.new(layout_file_path).parse_layout_file
    rescue GithubError => e
      errors.add(:base, e.message)
      raise ActiveRecord::RecordInvalid, self
    end
    lessons.destroy_all
    lessons_params.each do |day_params|
      day_params[:lessons].each do |lesson_params|
        lesson = lessons.new
        lesson.name = lesson_params[:title]
        lesson.github_path = lesson_params[:github_path]
        lesson.work_type = lesson_params[:work_type]
        lesson.day_of_week = day_params[:day]
        lesson.public = true
        lesson.save
      end
    end
  end

  def deep_clone(course_to_assign_to)
    new_section = self.dup
    new_section.layout_file_path = nil
    new_section.course = course_to_assign_to
    new_section.save
    lessons.each do |lesson|
      new_lesson = lesson.dup
      new_lesson.section = new_section
      new_lesson.save
    end
    new_section
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
end
