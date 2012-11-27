class AddPublicToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :public, :boolean, :default => false, :null => false
    Lesson.all.each {|lesson| lesson.update_attributes(:public => true)}
  end
end
