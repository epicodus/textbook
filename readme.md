#Textbook

Textbook is a simple content management system. It organizes content into pages, which are grouped into sections. A table of contents lists all of the sections, and each section index lists the pages in the section. At the bottom of each page are navigation links to the next and previous pages, as well as to the section index and the table of contents.

If a user creates an account and signs in, if they leave the site and return to the homepage, they will be redirected to the last page they visited.

To create new sections and pages, a user must be signed in and have the `author` attribute set to `true`. This attribute can only be set from the console. If an author deletes a page or section, the content is maintained in the database via the [Paranoia](https://github.com/radar/paranoia) gem to allow recovery from accidental deletions.

The first page of the first section is used as the homepage. If no pages exist yet, a placeholder page is displayed. The code for this logic could probably use some love.


To do:

* As an author, I should be able to put some or all of my content behind a paywall, so that I require users to pay me for the work I did to make my site.
* As an author, I should be able to put the sign in/sign up links and navigation links in a different place on the homepage, so that I can have a marketing site as my homepage while the rest of the content is more textbook-style.
* As an author, I should be able to un-delete my content from the user interface, so that I don't have to use the console if I need to un-delete something.
* As an author, I should be able to restore a previous version of a page, so that I can see what changes I've made over time and undo accidental changes.
* As a student, I should be able to give feedback on a page, so that I can point out if something isn't clear or tell the authors how much I like what they've written.
* As an author, I should be able to provide custom CSS for my site, so that I can give it a unique look and feel.
