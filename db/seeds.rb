User.create(email: 'author@epicodus.com', password: 'password', author: true)
User.create(email: 'student@epicodus.com', password: 'password')
Course.create(name: 'Course 1', number: 1, public: true)
Section.create(name: 'Section 1', number: 1, public: true, course: Course.first)

3.times do |n|
  Lesson.create(
    name: "Lesson",
    content: 'This is the lesson content.',
    cheat_sheet: 'This is the cheat sheet.',
    update_warning: 'This is the update warning',
    video_id: 12345,
    public: true,
    section: Section.first
  )
end
