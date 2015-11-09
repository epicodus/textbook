class RenameChapterIdToCourseId < ActiveRecord::Migration
  def change
    rename_column :sections, :chapter_id, :course_id
  end
end
