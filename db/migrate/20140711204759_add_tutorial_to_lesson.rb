class AddTutorialToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :tutorial, :boolean
  end
end
