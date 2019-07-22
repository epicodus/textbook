class RenameSectionGithubPathToLayoutFilePath < ActiveRecord::Migration[5.2]
  def up
    rename_column :sections, :github_path, :layout_file_path
  end

  def down
    rename_column :sections, :layout_file_path, :github_path
  end
end
