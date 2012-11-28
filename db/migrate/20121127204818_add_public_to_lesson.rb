class AddPublicToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :public, :boolean, :default => false, :null => false
  end
end
