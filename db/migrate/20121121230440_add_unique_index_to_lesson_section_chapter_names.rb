class AddUniqueIndexToLessonSectionChapterNames < ActiveRecord::Migration
  def change
    add_index :lessons, :name, :unique => :true
    add_index :sections, :name, :unique => :true
    add_index :chapters, :name, :unique => :true
  end
end
