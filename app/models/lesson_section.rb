class LessonSection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :section

  before_validation :set_number, on: :create

  validates :section, presence: true
  validates :number, presence: true, numericality: { only_integer: true }

  default_scope -> { order :number }

private

  def set_number
    self.number = section.try(:lesson_sections).try(:last).try(:number).to_i + 1
  end
end
