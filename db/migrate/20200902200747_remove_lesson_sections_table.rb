class RemoveLessonSectionsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :lesson_sections
    remove_column :courses, :deleted_at
    remove_column :sections, :deleted_at
    remove_column :lessons, :deleted_at
  end
end
