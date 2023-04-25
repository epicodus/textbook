require 'find'
require 'csv'

desc "tmp search and replace"
task :tmp_search_and_replace => [:environment] do
  replacements = read_replacements_from_csv('tmp/fix_image_links.csv')
  search_and_replace_in_directory('curriculum', replacements)  
end

def search_and_replace_in_file(file_path, replacements)
  text = File.read(file_path)
  has_newline_at_end = text[-1] == "\n"
  replacements_made = false
  replacements.each do |search_text, replacement_text|
    if text.include?(search_text)
      text.gsub!(search_text, replacement_text)
      replacements_made = true
    end
  end
  if replacements_made
    File.open(file_path, "w") do |file|
      file.write(text)
      file.write("\n") if has_newline_at_end && text[-1] != "\n"
    end
  end  
end

def search_and_replace_in_directory(directory_path, replacements)
  Find.find(directory_path) do |path|
    if File.file?(path) && File.fnmatch("*.md", path)
      search_and_replace_in_file(path, replacements)
    end
  end
end

def read_replacements_from_csv(csv_path)
  replacements = []
  CSV.foreach(csv_path, headers: false) do |row|
    replacements << [row[0], row[1].gsub('c#', 'c%23').gsub(' ', '+')]
  end
  replacements.uniq
end
