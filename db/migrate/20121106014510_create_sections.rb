class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name, :null => false
    end
  end
end
