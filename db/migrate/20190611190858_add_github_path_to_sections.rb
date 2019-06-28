class AddGithubPathToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :github_path, :string
  end
end
