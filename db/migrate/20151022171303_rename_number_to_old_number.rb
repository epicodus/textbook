class RenameNumberToOldNumber < ActiveRecord::Migration
  def change
    rename_column :lessons, :number, :old_number
    change_column_null :lessons, :old_number, true
  end
end
