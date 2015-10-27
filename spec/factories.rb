FactoryGirl.define do
  factory :author, :class => User do
    email 'author@epicodus.com'
    password 'password'
    author true
  end

  factory :student, :class => User do
    email 'student@epicodus.com'
    password 'password'
  end

  factory :chapter do
    sequence(:name) {|n| "Chapter #{n}"}
    public true
    sequence(:number) {|n| n}
  end

  factory :section do
    sequence(:name) { |n| "Section #{n}" }
    association :chapter, :factory => :chapter
    public true
    sequence(:number) { |n| n }
  end

  factory :lesson do
    sequence(:name) { |n| "Lesson #{n}" }
    content "This is the lesson content."
    cheat_sheet "This is the cheat sheet."
    update_warning "This is the update warning."
    video_id 12345
    association :section, :factory => :section
    sequence(:number) { |n| n }
    public true
    after(:create) do |lesson|
      lesson_section = LessonSection.find_by(section_id: lesson.sections.first.id, lesson_id: lesson.id)
      lesson_section.update(number: lesson.number)
    end
  end
end
