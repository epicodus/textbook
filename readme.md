#Textbook

[![Code Climate](https://codeclimate.com/github/epicodus/textbook.png)](https://codeclimate.com/github/epicodus/textbook) [![Dependency status](https://gemnasium.com/epicodus/textbook.png)](https://gemnasium.com/epicodus/textbook)
[![Build status](https://travis-ci.org/epicodus/textbook.svg?branch=master)](https://travis-ci.org/epicodus/textbook)

Textbook is a simple content management system for textbook-like sites. It organizes content into lessons, which are grouped into sections. A table of contents lists all of the sections, and each section index lists the lessons in the section. At the bottom of each lesson are navigation links to the next and previous lessons, as well as to the section index and the table of contents.

To create new sections and lessons, a user must be signed in and have the `author` attribute set to `true`. This attribute can only be set from the Rails console. If an author deletes a lesson, the content is maintained in the database via the [Paranoia](https://github.com/radar/paranoia) gem to allow recovery from accidental deletions.

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
* WEB_CONCURRENCY (for Unicorn workers; defaults to 3)

Currently it is not necessary to set any of them in development or test environments.
