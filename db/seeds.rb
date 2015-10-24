require 'factory_girl_rails'

FactoryGirl.create :author
FactoryGirl.create :student

10.times do
  chapter = FactoryGirl.create :chapter
  4.times do
    section = FactoryGirl.create :section, :chapter => chapter
    20.times do
      FactoryGirl.create :lesson, :section => section
    end
  end
end
