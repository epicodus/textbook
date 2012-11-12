class CreateChaptersTable < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :sort_order

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
