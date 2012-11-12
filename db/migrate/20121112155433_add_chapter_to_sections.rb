class AddChapterToSections < ActiveRecord::Migration
  def change
    add_column :sections, :chapter_id, :integer, :null => false
  end
end
