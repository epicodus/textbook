class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :slug
      t.integer :number
      t.boolean :public
    end
  end
end
