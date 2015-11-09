class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  default_scope -> { order :number }

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true
  validates :course, :presence => true
  validate :name_does_not_conflict_with_routes

  has_many :lesson_sections, inverse_of: :section
  has_many :lessons, through: :lesson_sections
  belongs_to :course

private

  def name_does_not_conflict_with_routes
    conflicting_names = ['sections', 'lessons', 'courses', 'table of contents']
    if conflicting_names.include?(name.try(:downcase))
      errors.add(:name, "cannot be #{name}")
      false
    end
  end
end
