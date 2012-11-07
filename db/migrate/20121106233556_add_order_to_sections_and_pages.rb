class AddOrderToSectionsAndPages < ActiveRecord::Migration
  def change
    add_column :sections, :sort_order, :integer, :null => false
    add_column :pages, :sort_order, :integer, :null => false
  end
end
