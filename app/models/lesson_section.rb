class LessonSection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :section

  acts_as_paranoid

  before_validation :set_number, on: :create

  validates :section, presence: true
  validates :number, presence: true, numericality: { only_integer: true }

  default_scope -> { order :number }

  enum work_type: [ :lesson, :exercise ]
  enum day_of_week: [ :weekend, :monday, :tuesday, :wednesday, :thursday, :friday ]

private

  def set_number
    self.number = section.try(:lesson_sections).try(:last).try(:number).to_i + 1
  end
end
