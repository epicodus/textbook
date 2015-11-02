class CreateLessonSections < ActiveRecord::Migration
  def change
    create_table :lesson_sections do |t|
      t.integer :lesson_id
      t.integer :section_id
      t.integer :number
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :lesson_sections, :lesson_id
    add_index :lesson_sections, :section_id
    add_index :lesson_sections, :number

  end
end
