class RemoveUniqueConstraintOnLessonsSections < ActiveRecord::Migration
  def change
    remove_index :lessons, :name => "index_lessons_on_name"
    remove_index :sections, :name => "index_sections_on_name"
    add_index :lessons, :name
    add_index :sections, :name
  end
end
