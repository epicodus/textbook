class RenameSectionIdToOldSectionId < ActiveRecord::Migration
  def change
    rename_column :lessons, :section_id, :old_section_id
    change_column_null :lessons, :old_section_id, true
  end
end
