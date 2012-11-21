class RenameLessonTitleToNameAndBodyToContent < ActiveRecord::Migration
  def change
    rename_column :lessons, :title, :name
    rename_column :lessons, :body, :content
  end
end
