class AddTeacherNotesToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :teacher_notes, :text
  end
end
