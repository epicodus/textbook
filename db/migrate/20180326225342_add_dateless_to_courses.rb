class AddDatelessToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :dateless, :boolean
  end
end
