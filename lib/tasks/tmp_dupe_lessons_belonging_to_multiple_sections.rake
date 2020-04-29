desc "tmp_dupe_lessons_belonging_to_multiple_sections"
task :tmp_dupe_lessons_belonging_to_multiple_sections => [:environment] do
  filename = File.join(Rails.root.join('tmp'), 'tmp_dupe_lessons_belonging_to_multiple_sections.txt')

  tracks_to_save = Track.where(name: [
    'Intro to Programming (Evening)',
    'C# and React',
    'Ruby and React',
    'React (Part-Time)',
    'Workshops',
    'Fidgetech',
    'Internship and Job Search'
  ])
  additional_courses_to_save = Course.where(name: ['User Interfaces', 'Android'])

  courses_to_save = Course.where(id: additional_courses_to_save + Course.where(id: tracks_to_save.map { |track| track.courses.where(public: true) }.flatten.uniq))
  sections_to_save = Section.where(id: courses_to_save.map { |course| course.sections.where(public: true) }.flatten.uniq)
  lessons_to_save = Lesson.where(id: sections_to_save.map { |section| section.lessons.where(public: true) }.flatten.uniq)

  File.open(filename, 'w') do |file|
    # FIX LESSONS BELONGING TO MULTIPLE SECTIONS
    file.puts "LESSONS BELONGING TO MULTIPLE SECTIONS:"
    lessons_belonging_to_multiple_sections = lessons_to_save.select { |lesson| lesson.sections.count > 1 }
    if lessons_belonging_to_multiple_sections.any?
      lessons_belonging_to_multiple_sections.each do |lesson|
        file.puts lesson.name
        lesson.sections.each do |section|
          file.puts "  #{section.name} [#{section.course.name}]"
          new_lesson = lesson.dup
          section.lessons << new_lesson
          section.lessons.delete(lesson)
        end
        lesson.destroy if lesson.reload.sections.empty?
        file.puts ""
      end
    else
      file.puts 'none :)'
      file.puts ''
    end

    # LIST SECTIONS MISSING LAYOUT FILE PATH
    file.puts "SECTIONS MISSING LAYOUT FILE PATH:" if sections_to_save.where(layout_file_path: nil).any?
    sections_to_save.where(layout_file_path: nil).each do |section|
      file.puts "#{section.name} [#{section.course.name}]" unless section.course.name == 'Android' || section.course.name == 'User Interfaces'
    end
    file.puts '[All sections from Android & User Interfaces courses]'
  end

  if Rails.env.production?
    mg_client = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
    mb_obj = Mailgun::MessageBuilder.new()
    mb_obj.set_from_address("it@epicodus.com");
    mb_obj.add_recipient(:to, "mike@epicodus.com");
    mb_obj.set_subject("tmp_dupe_lessons_belonging_to_multiple_sections");
    mb_obj.set_text_body("rake task: tmp_dupe_lessons_belonging_to_multiple_sections");
    mb_obj.add_attachment(filename, "tmp_dupe_lessons_belonging_to_multiple_sections.txt");
    result = mg_client.send_message("epicodus.com", mb_obj)
    puts result.body.to_s
    puts "Sent #{filename.to_s}"
  else
    puts "Exported #{filename.to_s}"
  end
end
