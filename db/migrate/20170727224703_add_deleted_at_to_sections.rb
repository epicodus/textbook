class AddDeletedAtToSections < ActiveRecord::Migration
  def change
    add_column :sections, :deleted_at, :datetime
    add_index :sections, :deleted_at
  end
end
