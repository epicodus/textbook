desc "export list of offline images in public lessons"
task :export_offline_images_list => [:environment] do
  offline_images = {}
  Course.where(public: true).each do |course|
    course.sections.where(public: true).each do |section|
      section.lessons.where(public: true).each do |lesson|
        if lesson.content.include? 'https://learnhowtoprogram.s3.us-west-2.amazonaws.com/'
          image_link_pattern = /https:\/\/learnhowtoprogram\.s3\.us-west-2\.amazonaws\.com\/(?:[^\/]+\/)+[^\/]+\.(?:png|gif|jpg|jpeg)/
          links = lesson.content.scan(image_link_pattern)
          links.each do |url|
            is_image = FastImage.type(url, raise_on_failure: false)
            unless is_image
              route = "https://www.learnhowtoprogram.com#{Rails.application.routes.url_helpers.course_section_lesson_path(lesson.section.course, lesson.section, lesson)}"
              offline_images[course.name] ||= {}
              offline_images[course.name][section.name] ||= {}
              offline_images[course.name][section.name][lesson.name] ||= { lesson_path: route, urls: [] }
              offline_images[course.name][section.name][lesson.name][:urls] << url
            end
          end
        end
      end
    end
  end

  filename = File.join(Rails.root.join('tmp'), 'offline-images.txt')
  File.open(filename, 'w') do |file|
    offline_images.each do |course, sections|  
      file.puts ''
      file.puts '------------------------------------'
      file.puts "COURSE: #{course.upcase}"
      sections.each do |section, lessons|
        file.puts ''
        file.puts "  SECTION: #{section.upcase}"
        lessons.each do |lesson_name, lesson|
          file.puts ''
          file.puts "    #{lesson_name}"
          file.puts "    #{lesson[:lesson_path]}"
          lesson[:urls].each do |url|
            file.puts "      #{url}"
          end
        end
      end
    end
  end

  if Rails.env.production?
    mg_client = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
    mb_obj = Mailgun::MessageBuilder.new()
    mb_obj.set_from_address('it@epicodus.com');
    mb_obj.add_recipient(:to, 'curriculum@epicodus.com')
    mb_obj.set_subject(offline_images.empty? ? 'No offline images :)' : 'offline-images.txt')
    mb_obj.set_text_body(offline_images.empty? ? 'No offline images :)' : 'rake task: export_offline_images_list')
    mb_obj.add_attachment(filename, 'offline-images.txt') unless offline_images.empty?
    result = mg_client.send_message('epicodus.com', mb_obj)
    puts result.body.to_s
    puts offline_images.empty? ? 'No offline images :)' : "Sent #{filename.to_s}"
  else
    puts offline_images.empty? ? 'No offline images :)' : "Exported to #{filename.to_s}"
  end
end
