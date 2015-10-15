class CreateLessonSections < ActiveRecord::Migration
  def change
    create_table :lesson_sections do |t|
      t.integer :lesson_id
      t.integer :section_id

      t.timestamps
    end
  end
end
