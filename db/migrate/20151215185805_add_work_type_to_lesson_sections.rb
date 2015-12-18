class AddWorkTypeToLessonSections < ActiveRecord::Migration
  def change
    add_column :lesson_sections, :work_type, :integer, default: 0
  end
end
