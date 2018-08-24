class AddLevelToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :level, :integer
  end
end
