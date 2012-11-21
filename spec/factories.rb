FactoryGirl.define do
  factory :author, :class => User do
    email {Faker::Internet.email}
    password {Faker::Lorem.words(3).join}
    author true
  end

  factory :student, :class => User do
    email {Faker::Internet.email}
    password {Faker::Lorem.words(3).join}
  end

  factory :chapter do
    name {Faker::Lorem.words(1).join}
    sequence(:number) {|n| n}
  end

  factory :section do
    name {Faker::Lorem.words(2).join}
    association :chapter, :factory => :chapter
    sequence(:number) {|n| n}
  end

  factory :lesson do
    name {Faker::Lorem.words(3).join(" ")}
    content {Faker::Lorem.paragraph}
    association :section, :factory => :section
    sequence(:number) {|n| n}
  end
end
