desc "for temporary use while building github lhtp integration"
task :tmp_clear_course, [:course] => [:environment] do |t, args|
  course = Course.find_by(name: 'test course')
  course.sections.each do |section|
    section.lessons.destroy_all
    section.lesson_sections.destroy_all
    section.really_destroy!
    Lesson.where('created_at > ?', Date.today).destroy_all
    LessonSection.where('created_at > ?', Date.today).destroy_all
  end
end
