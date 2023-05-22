task :export_for_lhtp2 => [:environment] do
  courses = Course.where(public: true)
  courses.each do |course|
    File.open(course.slug + '.yaml', 'w') do |file|
      file.puts 'title: ' + course.name
      file.puts 'slug: ' + course.slug
      course.dateless ? file.puts('show_weeks_and_days: false') : file.puts('show_weeks_and_days: true')
      file.puts 'sections:'
      course.sections.where(public: true).each_with_index do |section, i|
        file.puts '  - title: ' + section.name
        file.puts '    slug: ' + section.slug
        file.puts '    number: ' + i.to_s
        file.puts '    week: ' + section.week.to_s
        file.puts '    path: ' + section.layout_file_path
      end
    end
  end
end
