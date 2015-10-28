class LessonSection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :section

  acts_as_paranoid

  default_scope -> { order :number }
end
