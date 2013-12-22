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
    content "A fantastic lesson indeed."
    cheat_sheet "Notes."
    video_id 12345
    association :section, :factory => :section
    sequence(:number) { |n| n }
    public true
  end
end
