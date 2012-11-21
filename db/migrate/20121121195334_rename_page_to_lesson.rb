class RenamePageToLesson < ActiveRecord::Migration
  def change
    rename_table :pages, :lessons
  end
end
