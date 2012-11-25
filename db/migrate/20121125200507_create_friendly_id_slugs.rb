class CreateFriendlyIdSlugs < ActiveRecord::Migration
  def up
    add_column :chapters, :slug, :string
    add_column :sections, :slug, :string
    add_column :lessons, :slug, :string

    models = [Chapter, Section, Lesson]
    models.each do |model|
      model.unscoped.all.each do |instance|
        instance.slug = instance.name.parameterize
        begin
          instance.slug = instance.name.parameterize
          instance.save!
        rescue
          instance.name = instance.name + ' (deleted)'
          instance.slug = instance.name.parameterize
          instance.save!
        end
      end
    end

    change_column :chapters, :slug, :string, :null => false
    change_column :sections, :slug, :string, :null => false
    change_column :lessons, :slug, :string, :null => false
  end

  def down
    remove_column :chapters, :slug
    remove_column :sections, :slug
    remove_column :lessons, :slug
  end
end
