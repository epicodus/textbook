class AddGithubPathToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :github_path, :string
  end
end
