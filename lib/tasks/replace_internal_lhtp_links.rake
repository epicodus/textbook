desc "export list of links to old course"
task :replace_internal_lhtp_links, [:course] => [:environment] do |t, args|
  filename = File.join(Rails.root.join('tmp'), 'links.txt')
  File.open(filename, 'w') do |file|
    errors = []
    course_id = args.course || ""
    while course_id == ""
      puts "Enter course id or slug:"
      course_id = STDIN.gets.chomp
    end
    course = Course.friendly.find(course_id)
    old_course = Course.find(course.slug.gsub('fidgetech-',''))
    file.puts "COURSE: #{course.name}"
    file.puts ""
    course.lessons.each do |lesson|
      links_to_non_fidgetech_sections = lesson.content.scan(/\((https?:\/\/(www.)?learnhowtoprogram\.com\/(?!fidgetech).*?)\)/).map {|link| link[0]}
      links_to_non_fidgetech_sections.each do |url|
        old_lesson_linked_to = old_course.lessons.find_by(slug: url.split('/').last)
        if old_lesson_linked_to.nil?
          errors << { lesson: lesson, url: url }
        else
          fidgetech_lesson = course.lessons.find_by(name: old_lesson_linked_to.name)
          replacement_url = "https://www.learnhowtoprogram.com/fidgetech-intro-to-programming/#{fidgetech_lesson.sections.first.slug}/#{fidgetech_lesson.slug}"
          file.puts "SECTION: #{lesson.sections.first.name} | LESSON: #{lesson.name}"
          file.puts "REPLACING: #{url.split('.com/').last}"
          file.puts "WITH: #{replacement_url.split('.com/').last}"
          file.puts ""
          lesson.update(content: lesson.content.gsub(url, replacement_url))
        end
      end
    end
    if errors.any?
      file.puts ""
      file.puts "---------------------------------------------------------------------------------------------------------"
      file.puts "UNABLE TO UPDATE:"
      errors.each do |error|
        url = error[:url]
        lesson = error[:lesson]
        file.puts ""
        file.puts "Unable to update: #{url}"
        file.puts "(#{lesson.sections.first.name} | #{lesson.name})"
      end
    end
  end
  if Rails.env.production?
    mg_client = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
    mb_obj = Mailgun::MessageBuilder.new()
    mb_obj.set_from_address("it@epicodus.com");
    mb_obj.add_recipient(:to, "mike@epicodus.com");
    mb_obj.set_subject("Replaced Fidgetech links");
    mb_obj.set_text_body("rake task: replace_internal_lhtp_links");
    mb_obj.add_attachment(filename, "links.txt");
    result = mg_client.send_message("epicodus.com", mb_obj)
    puts result.body.to_s
    puts "Sent #{filename.to_s}"
  else
    puts "Exported #{filename.to_s}"
  end
end
