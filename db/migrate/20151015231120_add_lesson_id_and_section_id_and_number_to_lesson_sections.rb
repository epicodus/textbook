class AddLessonIdAndSectionIdAndNumberToLessonSections < ActiveRecord::Migration
  def up
    Lesson.find_by_sql("SELECT section_id, id, number, created_at, updated_at FROM lessons").each do |lesson|
      ActiveRecord::Base.connection.execute "INSERT INTO lesson_sections (section_id, lesson_id, number, created_at, updated_at) VALUES (#{lesson.section_id}, #{lesson.id}, #{lesson.number}, '#{Time.zone.now.to_formatted_s(:db)}', '#{Time.zone.now.to_formatted_s(:db)}')"
    end
  end

  def down
    ActiveRecord::Base.connection.execute "DELETE FROM lesson_sections"
  end
end
