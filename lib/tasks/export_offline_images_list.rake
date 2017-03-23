desc "export list of offline images in public lessons"
task :export_offline_images_list => [:environment] do
  filename = File.join(Rails.root.join('tmp'), 'offline-images.txt')
  File.open(filename, 'w') do |file|
    Course.all.each do |course|
      if course.public
        file.puts("")
        file.puts("COURSE: #{course.name.upcase}")
        course.sections.each do |section|
          if section.public
            section.lessons.each do |lesson|
              if lesson.public && lesson.content.include?("dropbox")
                links = lesson.content.scan(/(\/\/(dl|www)\.dropbox.*?)\)/)
                links.each do |link|
                  url = "http:" + link[0]
                  response = HTTParty.head(url)
                  unless response.content_type.include? "image"
                    file.puts("#{section.name.upcase} | #{lesson.name}:")
                    file.puts(link[0])
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  puts "Exported to #{filename.to_s}"
end
