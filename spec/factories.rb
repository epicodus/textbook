FactoryBot.define do
  factory :author, :class => User do
    email {'author@epicodus.com'}
    password {'password'}
    author {true}
  end

  factory :student, :class => User do
    email {'student@epicodus.com'}
    password {'password'}
  end

  factory :track do
    sequence(:name) {|n| "Track #{n}"}
    public { true }
    sequence(:number) {|n| n}
  end

  factory :course do
    sequence(:name) {|n| "Course #{n}"}
    public { true }
    sequence(:number) {|n| n}
  end

  factory :section do
    sequence(:name) { |n| "Section #{n}" }
    association :course, :factory => :course
    public { true }
    sequence(:week) { |n| n }
  end

  factory :lesson do
    sequence(:name) { |n| "Lesson #{n}" }
    content { "This is the lesson content." }
    cheat_sheet { "This is the cheat sheet." }
    update_warning { "This is the update warning." }
    teacher_notes { "This is the teacher notes section." }
    video_id { 12345 }
    association :section, :factory => :section
    public { true }
  end
end
