class Course < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  acts_as_paranoid

  default_scope -> { order :number }
  scope :with_sections, -> { includes(:sections).where.not(sections: { id: nil }) }

  before_validation :set_number, on: :create

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true

  has_many :sections, :dependent => :destroy
  has_many :lessons, :through => :sections
  has_and_belongs_to_many :tracks

  accepts_nested_attributes_for :sections
  accepts_nested_attributes_for :lessons

  def deep_clone
    new_course = self.dup
    new_course.name = name + " (copy)"
    new_course.public = false
    new_course.save
    sections.each do |section|
      new_section = section.deep_clone(new_course)
      new_section.course = new_course
      new_section.save
    end
    new_course
  end

private

  def set_number
    self.number = Course.all.last.try(:number).to_i + 1
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
