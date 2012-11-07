class AddTimestampsToModels < ActiveRecord::Migration
  def change
    add_column :pages, :created_at, :datetime, :null => false
    add_column :pages, :updated_at, :datetime
    add_column :pages, :deleted_at, :datetime
    add_column :sections, :created_at, :datetime, :null => false
    add_column :sections, :updated_at, :datetime
    add_column :sections, :deleted_at, :datetime
  end
end
