FactoryGirl.define do
  factory :author, :class => User do
    email Faker::Internet.email
    password Faker::Lorem.words(3).join
    author true
  end

  factory :student, :class => User do
    email Faker::Internet.email
    password Faker::Lorem.words(3).join
  end

  factory :section do
    name Faker::Lorem.words(2).join
    sequence(:sort_order) {|n| n}
  end

  factory :page do
    title Faker::Lorem.words(3).join(" ")
    body Faker::Lorem.paragraph
    association :section, :factory => :section
    sequence(:sort_order) {|n| n}
  end
end
