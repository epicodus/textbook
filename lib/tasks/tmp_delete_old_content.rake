desc "tmp delete old content"
task :tmp_delete_old_content => [:environment] do
  filename = File.join(Rails.root.join('tmp'), 'tmp_delete_old_content.txt')

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
    file.puts "Tracks to save: #{tracks_to_save.count}"
    file.puts "Courses to save: #{courses_to_save.count}"
    file.puts "Sections to save: #{sections_to_save.count}"
    file.puts "Lessons to save: #{lessons_to_save.count}"
    file.puts ""

    # DELETE ALL CONTENT NOT SAVED
    Lesson.where.not(id: lessons_to_save).destroy_all
    Section.where.not(id: sections_to_save).destroy_all
    Course.where.not(id: courses_to_save).destroy_all
    Track.where.not(id: tracks_to_save).destroy_all
    Lesson.only_deleted.each { |lesson| lesson.really_destroy! }
    Section.only_deleted.each { |section| section.really_destroy! }
    Course.only_deleted.each { |course| course.really_destroy! }

    file.puts "Tracks remaining: #{Track.count}"
    file.puts "Courses remaining: #{Course.count}"
    file.puts "Sections remaining: #{Section.count}"
    file.puts "Lessons remaining: #{Lesson.count}"
    file.puts ""

    # LIST LESSONS BELONGING TO MULTIPLE SECTIONS
    file.puts "LESSONS BELONGING TO MULTIPLE SECTIONS:"
    lessons_belonging_to_multiple_sections = lessons_to_save.select { |lesson| lesson.sections.count > 1 }
    if lessons_belonging_to_multiple_sections.any?
      lessons_belonging_to_multiple_sections.each do |lesson|
        file.puts lesson.name
        lesson.sections.each do |section|
          file.puts "  #{section.name} [#{section.course.name}]"
        end
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
    mb_obj.set_subject("tmp_delete_old_content Fidgetech links");
    mb_obj.set_text_body("rake task: tmp_delete_old_content");
    mb_obj.add_attachment(filename, "tmp_delete_old_content.txt");
    result = mg_client.send_message("epicodus.com", mb_obj)
    puts result.body.to_s
    puts "Sent #{filename.to_s}"
  else
    puts "Exported #{filename.to_s}"
  end
end
