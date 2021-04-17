desc "rename links to master branches to main"
task :rename_master_links_to_main => [:environment] do
  Section.where.not(layout_file_path: nil).each do |section|
    section.update_columns(layout_file_path: section.layout_file_path.sub('/master/', '/main/'))
  end
  Lesson.where.not(github_path: nil).each do |lesson|
    lesson.update_columns(github_path: lesson.github_path.sub('/master/', '/main/'))
  end
end
