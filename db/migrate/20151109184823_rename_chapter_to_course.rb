class RenameChapterToCourse < ActiveRecord::Migration
  def change
    rename_table :chapters, :courses
  end
end
