class MakeUpdatedAtNullFalse < ActiveRecord::Migration
  def change
    change_column :pages, :updated_at, :datetime, :null => false
    change_column :sections, :updated_at, :datetime, :null => false
  end
end
