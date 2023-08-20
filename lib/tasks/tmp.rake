task :tmp => [:environment] do
  Course.where_public.each do |course|
    puts course.slug
    course.sections.where_public.each do |section|
      puts '  ' + section.layout_file_path.split('/')[4]
    end
    puts ''
  end
end
