class UpdateLessonsRemoveNullConstraintOnSlugs < ActiveRecord::Migration
  def change
    change_column :lessons, :slug, :string, :limit => 255, :null => true
  end
end
