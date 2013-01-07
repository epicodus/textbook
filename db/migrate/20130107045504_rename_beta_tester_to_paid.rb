class RenameBetaTesterToPaid < ActiveRecord::Migration
  def change
    rename_column :users, :beta_tester, :paid
  end
end
