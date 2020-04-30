class MigrateLessonSectionsToLessons < ActiveRecord::Migration[5.2]
  def up
    Lesson.all.each do |lesson|
      lesson_section = LessonSection.find_by(lesson_id: lesson.id)
      section_id = lesson_section.section_id
      number = lesson_section.number
      work_type = lesson_section.work_type
      day_of_week = lesson_section.day_of_week
      lesson.update_columns(section_id: section_id, number: number, work_type: work_type, day_of_week: day_of_week)
    end
  end

  def down
    Lesson.update_all(section_id: nil, number: nil, work_type: nil, day_of_week: nil)
  end
end
