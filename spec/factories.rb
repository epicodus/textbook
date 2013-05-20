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
    name {Faker::Lorem.words.join}
    public true
    sequence(:number) {|n| n}
  end

  factory :section do
    name {Faker::Lorem.words.join}
    association :chapter, :factory => :chapter
    public true
    sequence(:number) {|n| n}
  end

  factory :lesson do
    name {Faker::Lorem.words.join}
    content {Faker::Lorem.paragraph}
    association :section, :factory => :section
    sequence(:number) {|n| n}
    public true
  end
end
