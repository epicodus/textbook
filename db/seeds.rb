# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'student@learnhowtoprogram.com', password: 'ilovetolearn')
author = User.create(email: 'author@learnhowtoprogram.com', password: 'ilovetoteach')
author.author = true
author.save