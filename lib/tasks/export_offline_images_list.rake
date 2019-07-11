desc "export list of offline images in public lessons"
task :export_offline_images_list => [:environment] do
  counter = 0
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
                    counter += 1
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if counter > 0
    begin
      mg_client = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
      mb_obj = Mailgun::MessageBuilder.new()
      mb_obj.set_from_address("it@epicodus.com");
      mb_obj.add_recipient(:to, "curriculum@epicodus.com");
      mb_obj.add_recipient(:cc, "ben@epicodus.com");
      mb_obj.set_subject("offline-images.txt");
      mb_obj.set_text_body("rake task: export_offline_images_list");
      mb_obj.add_attachment(filename, "offline-images.txt");
      result = mg_client.send_message("epicodus.com", mb_obj)
      puts result.body.to_s
      puts "Sent #{filename.to_s}"
    rescue
      puts "Exported to #{filename.to_s}"
    end
  else
    puts "No offline images :)"
  end
end
