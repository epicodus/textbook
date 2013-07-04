#Textbook

[![Code Climate](https://codeclimate.com/github/epicodus/textbook.png)](https://codeclimate.com/github/epicodus/textbook) [![Dependency Status](https://gemnasium.com/epicodus/textbook.png)](https://gemnasium.com/epicodus/textbook)

Textbook is a simple content management system for textbook-like sites. It organizes content into lessons, which are grouped into sections. A table of contents lists all of the sections, and each section index lists the lessons in the section. At the bottom of each lesson are navigation links to the next and previous lessons, as well as to the section index and the table of contents.

To create new sections and lessons, a user must be signed in and have the `author` attribute set to `true`. This attribute can only be set from the console. If an author deletes a lesson or section, the content is maintained in the database via the [Paranoia](https://github.com/radar/paranoia) gem to allow recovery from accidental deletions.

The first lesson of the first section is used as the homepage. If no lessons exist yet, a placeholder lesson is displayed. The code for this logic could probably use some love.

Pull requests are welcome :)

##Environmental variables

Environmental variables can be set in .bashrc, a .env file for use with Foreman, or in Heroku's config. See the [Heroku documentation](https://devcenter.heroku.com/articles/config-vars) for more information.

Here is a list of environmental variables that need to be set:

* ACTION_MAILER_DEFAULT_URL_HOST
* ACTION_MAILER_SMTP_ADDRESS
* ACTION_MAILER_SMTP_DOMAIN
* ACTION_MAILER_SMTP_PORT
* ACTION_MAILER_SMTP_USER_NAME
* ACTION_MAILER_SMTP_PASSWORD
* DEVISE_MAILER_SENDER
* NEW_RELIC_LICENSE_KEY
* NEW_RELIC_APP_NAME
* RAILS_SECRET_TOKEN (a default value is provided for development and test environments)

Currently it is not necessary to set any of them in development or test environments.


##To do

* As an author, I want to be able to restore a previous version of a lesson, so that I can see what changes I've made over time and undo accidental changes.
* As a student, I want to be able to give feedback on a lesson, so that I can point out if something isn't clear or tell the authors how much I like what they've written.
* As a student, I want to have a list of key concepts I've learned on each lesson, as well as a list of all key concepts from the current section in a sidebar.


##License

Copyright (c) 2013 Michael Kaiser-Nyman

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.