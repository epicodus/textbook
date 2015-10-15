class LessonSection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :section
end
