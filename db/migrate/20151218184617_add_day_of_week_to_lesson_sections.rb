class AddDayOfWeekToLessonSections < ActiveRecord::Migration
  def change
    add_column :lesson_sections, :day_of_week, :integer, default: 0
  end
end
