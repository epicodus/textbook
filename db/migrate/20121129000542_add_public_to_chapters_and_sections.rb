class AddPublicToChaptersAndSections < ActiveRecord::Migration
  def change
    add_column :sections, :public, :boolean, :default => false, :null => false
    add_column :chapters, :public, :boolean, :default => false, :null => false
  end
end
