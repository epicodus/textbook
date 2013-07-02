class AddVideoUrlToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :video_id, :string
  end
end
