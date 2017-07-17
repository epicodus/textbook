desc "export list of offline links in new java section"
task :export_offline_links_java_tmp => [:environment] do
  counter = 0
  filename = File.join(Rails.root.join('tmp'), 'offline-links-java.txt')
  File.open(filename, 'w') do |file|
    course = Course.find_by(slug: "java-68306a8d-b845-4428-9186-1a41c2439e52")
    file.puts("COURSE: #{course.name.upcase}")
    course.sections.each do |section|
      section.lessons.each do |lesson|
        if lesson.content.include?("http")
          lhtp_links = lesson.content.scan(/\((https?:\/\/(www.)?learnhowtoprogram.*?)\)/)
          lhtp_links.each do |link|
            url = link[0]
            response = HTTParty.head(url, timeout: 60)
            if response.code == 400 && url.include?("http:")
              https_url = url.gsub("http:", "https:")
              response = HTTParty.head(https_url, timeout: 60)
            end
            unless response.code == 200
              file.puts("#{section.name.upcase} | #{lesson.name}:")
              file.puts(url)
              counter += 1
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
      mb_obj.set_subject("offline-links-java.txt");
      mb_obj.set_text_body("rake task: export_offline_links_java_tmp");
      mb_obj.add_attachment(filename, "offline-links-java.txt");
      result = mg_client.send_message("epicodus.com", mb_obj)
      puts result.body.to_s
      puts "Sent #{filename.to_s}"
    rescue
      puts "Exported to #{filename.to_s}"
    end
  else
    puts "No offline links in java section :)"
  end
end
