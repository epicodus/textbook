class AddUpdateWarningToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :update_warning, :text
  end
end
