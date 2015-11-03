class LessonSection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :section

  validates :section, presence: true
  validates :lesson, presence: true

  default_scope -> { order :number }
end
