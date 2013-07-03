require 'factory_girl_rails'

FactoryGirl.create :author
FactoryGirl.create :student
section = FactoryGirl.create :section
3.times {FactoryGirl.create :lesson, :section => section}
