class RemoveUniqueLessonNameValidationDbIndex < ActiveRecord::Migration
  def change
    remove_index :lessons, :name
    add_index :lessons, :name
  end
end
