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

  factory :course do
    sequence(:name) {|n| "Course #{n}"}
    public true
    sequence(:number) {|n| n}
  end

  factory :section do
    sequence(:name) { |n| "Section #{n}" }
    association :course, :factory => :course
    public true
    sequence(:week) { |n| n }
  end

  factory :lesson do
    sequence(:name) { |n| "Lesson #{n}" }
    content "This is the lesson content."
    cheat_sheet "This is the cheat sheet."
    teacher_notes "These are the teacher notes."
    update_warning "This is the update warning."
    video_id 12345
    association :section, :factory => :section
    public true
  end
end
