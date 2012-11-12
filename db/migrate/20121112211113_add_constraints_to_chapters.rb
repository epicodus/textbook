class AddConstraintsToChapters < ActiveRecord::Migration
  def change
    change_column :chapters, :name, :string, :null => false
    change_column :chapters, :number, :integer, :null => false
  end
end
