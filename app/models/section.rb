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

  has_many :lesson_sections, inverse_of: :section
  has_many :lessons, through: :lesson_sections
  belongs_to :course

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

private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def set_number
    self.number = course.try(:sections).try(:last).try(:number).to_i + 1
  end

  def name_does_not_conflict_with_routes
    conflicting_names = ['sections', 'lessons', 'courses']
    if conflicting_names.include?(name.try(:downcase))
      errors.add(:name, "cannot be #{name}")
      false
    end
  end
end
