class AddWeekToSections < ActiveRecord::Migration
  def change
    add_column :sections, :week, :integer
  end
end
