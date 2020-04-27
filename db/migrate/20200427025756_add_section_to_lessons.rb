class AddSectionToLessons < ActiveRecord::Migration[5.2]
  def up
    add_reference :lessons, :section, foreign_key: true
    Lesson.all.each do |lesson|
      lesson.update_columns(section_id: lesson.sections.first.id)
    end
  end

  def down
    remove_reference :lessons, :section
  end
end
