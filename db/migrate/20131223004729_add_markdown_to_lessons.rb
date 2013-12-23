class AddMarkdownToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :markdown, :text
  end
end
