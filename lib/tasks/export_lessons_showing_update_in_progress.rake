desc "export lessons showing update in progress"
task :export_lessons_showing_update_in_progress => [:environment] do
  counter = 0
  filename = File.join(Rails.root.join('tmp'), 'export_lessons_showing_update_in_progress.txt')
  File.open(filename, 'w') do |file|
    Lesson.where(public: true, content: 'Lesson queued for update... hit refresh soon!').each do |lesson|
      counter += 1
      file.puts("")
      file.puts("COURSE: #{lesson.section.course.name}")
      file.puts("SECTION: #{lesson.section.name}")
      file.puts("LESSON: #{lesson.name}")
    end
  end
  if counter > 0 && Rails.env.production?
    begin
      mg_client = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
      mb_obj = Mailgun::MessageBuilder.new()
      mb_obj.set_from_address("it@epicodus.com");
      mb_obj.add_recipient(:to, "curriculum@epicodus.com");
      mb_obj.set_subject("export_lessons_showing_update_in_progress.txt");
      mb_obj.set_text_body("rake task: export_lessons_showing_update_in_progress");
      mb_obj.add_attachment(filename, "export_lessons_showing_update_in_progress.txt");
      result = mg_client.send_message("epicodus.com", mb_obj)
      puts result.body.to_s
      puts "Sent #{filename.to_s}"
    rescue
      puts "Exported to #{filename.to_s}"
    end
  elsif counter > 0
    puts "Exported to #{filename.to_s}"
  else
    puts "No offline links :)"
  end
end
