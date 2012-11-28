class AddBetaTesterToStudent < ActiveRecord::Migration
  def change
    add_column :users, :beta_tester, :boolean, :default => false, :null => false
  end
end
