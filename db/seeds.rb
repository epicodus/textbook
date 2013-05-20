require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.create :author
FactoryGirl.create :student
3.times {FactoryGirl.create :chapter}
3.times {FactoryGirl.create :section}
3.times {FactoryGirl.create :lesson}
