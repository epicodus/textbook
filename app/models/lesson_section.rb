class LessonSection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :section

  default_scope -> { order :number }
end
