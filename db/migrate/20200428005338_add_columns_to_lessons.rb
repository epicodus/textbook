class AddColumnsToLessons < ActiveRecord::Migration[5.2]
  def up
    add_column :lessons, :work_type, :integer, default: 0
    add_column :lessons, :day_of_week, :integer, default: 0
    add_column :lessons, :number, :integer
    add_index :lessons, :number
    remove_column :lessons, :old_section_id
    remove_column :lessons, :old_number
    Lesson.all.each do |lesson|
      lesson_section = lesson.lesson_sections.first
      number = lesson_section.number
      work_type = lesson_section.work_type
      day_of_week = lesson_section.day_of_week
      lesson.update_columns(number: number, work_type: work_type, day_of_week: day_of_week)
    end
  end

  def down
    remove_column :lessons, :number
    remove_column :lessons, :work_type
    remove_column :lessons, :day_of_week
    add_column :lessons, :old_section_id, :integer
    add_column :lessons, :old_number, :integer
  end
end
