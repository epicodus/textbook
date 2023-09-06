task :tmp => [:environment] do
  tracks = Track.where(public: true)
  courses = tracks.map { |t| t.courses.where_public }.flatten
  courses.each do |course|
    puts course.slug
    course.sections.where_public.each do |section|
      puts '  ' + section.layout_file_path.split('/')[4] + ' | ' + section.slug
    end
    puts ''
  end
end
