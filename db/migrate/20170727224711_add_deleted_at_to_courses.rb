class AddDeletedAtToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :deleted_at, :datetime
    add_index :courses, :deleted_at
  end
end
