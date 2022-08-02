# Textbook

[![Coverage Status](https://coveralls.io/repos/epicodus/textbook/badge.svg)](https://coveralls.io/github/epicodus/textbook)
[![Code Climate](https://codeclimate.com/github/epicodus/textbook/badges/gpa.svg)](https://codeclimate.com/github/epicodus/textbook)

Textbook is a simple content management system for textbook-like sites. It organizes content into lessons, which are grouped into sections. A courses page lists all of the sections, and each section index lists the lessons in the section. At the bottom of each lesson are navigation links to the next and previous lessons, as well as to the section index and the courses index.

To create new sections and lessons, a user must be signed in and have the `author` attribute set to `true`. This attribute can only be set from the Rails console. If an author deletes a lesson, the content is maintained in the database via the [Paranoia](https://github.com/radar/paranoia) gem to allow recovery from accidental deletions.

The first lesson of the first section is used as the homepage. If no lessons exist yet, a placeholder lesson is displayed. The code for this logic could probably use some love.

Pull requests are welcome :)

## Configuration

1. `git clone https://github.com/epicodus/textbook.git`
1. `cd textbook`
1. `bundle`
1. `rake db:create && rake db:schema:load && rake db:seed`
1. `rails s` and visit [localhost:3000](http://localhost:3000)

## Environmental variables

Environmental variables can be set in .bashrc, a .env file for use with Foreman, or in Heroku's config. See the [Heroku documentation](https://devcenter.heroku.com/articles/config-vars) for more information.

Here is a list of environmental variables that need to be set:

* GITHUB_APP_ID
* GITHUB_INSTALLATION_ID
* GITHUB_CURRICULUM_ORGANIZATION
* GITHUB_APP_PEM
* ZAPIER_ERROR_REPORTING_WEBHOOK
