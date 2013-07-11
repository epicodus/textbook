class RemoveDeletedAtFromChaptersAndSections < ActiveRecord::Migration
  def up
    Chapter.where('deleted_at IS NOT NULL').each {|chapter| chapter.destroy}
    remove_column :chapters, :deleted_at

    Section.where('deleted_at IS NOT NULL').each {|section| section.destroy}
    remove_column :sections, :deleted_at
  end

  def down
    add_column :chapters, :deleted_at, :datetime
    add_column :sections, :deleted_at, :datetime
  end
end
