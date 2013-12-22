class AddCheatSheetToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :cheat_sheet, :text
  end
end
