class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :null => false
      t.text :body, :null => false
      t.references :section, :null => false
    end
  end
end
