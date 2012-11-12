class ChangeSortOrderToNumber < ActiveRecord::Migration
  def change
    rename_column :chapters, :sort_order, :number
    rename_column :sections, :sort_order, :number
    rename_column :pages, :sort_order, :number
  end
end
