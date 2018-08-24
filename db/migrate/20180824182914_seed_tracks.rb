class SeedTracks < ActiveRecord::Migration[5.2]
  def up
    pt = Course.find('intro-to-programming-evening')
    intro = Course.find('intro-to-programming')
    c = Course.find('c')
    ruby = Course.find('ruby')
    ui = Course.find('user-interfaces')
    js = Course.find('javascript')
    rails = Course.find('rails')
    react = Course.find('react')
    css = Course.find('css')
    fidgetech_intro = Course.find('fidgetech-intro-to-programming')
    fidgetech_c = Course.find('fidgetech-c')
    fidgetech_js = Course.find('fidgetech-javascript')
    fidgetech_react = Course.find('fidgetech-react')
    workshops = Course.find('workshops')
    internship_job_search = Course.find('internship-and-job-search')
    online = Course.find('intro-to-programming-online')
    java = Course.find('java')
    design = Course.find('design')
    drupal = Course.find('drupal')
    android = Course.find('android')
    php = Course.find('php')
    net = Course.find('net')
    ember = Course.find('ember-js')
    java_old = Course.find('java-old-reference-only')

    pt.update(level: 0)
    intro.update(level: 0)
    c.update(level: 1)
    ruby.update(level: 1)
    ui.update(level: 1)
    js.update(level: 2)
    rails.update(level: 3)
    react.update(level: 3)
    css.update(level: 1)
    fidgetech_intro.update(level: 0)
    fidgetech_c.update(level: 1)
    fidgetech_js.update(level: 2)
    fidgetech_react.update(level: 3)
    workshops.update(level: 0)
    internship_job_search.update(level: 4)
    online.update(level: 0)
    java.update(level: 1)
    design.update(level: 3)
    drupal.update(level: 3)
    android.update(level: 3)
    php.update(level: 1)
    net.update(level: 3)
    ember.update(level: 2)
    java_old.update(level: 1)

    track_pt = Track.create(name: 'Evening Intro to Programming', public: true)
    tract_c_react = Track.create(name: 'C# and React', public: true)
    track_frontend = Track.create(name: 'Front End Development', public: true)
    track_rubyrails = Track.create(name: 'Ruby and Rails', public: true)
    track_rubyreact = Track.create(name: 'Ruby and React', public: true)
    track_internship_job_search = Track.create(name: 'Internship and Job Search', public: true)
    track_workshops = Track.create(name: 'Workshops', public: true)
    track_fidgetech = Track.create(name: 'Fidgetech', public: true)
    track_archived = Track.create(name: 'Archived', public: true)

    track_pt.courses << [pt]
    tract_c_react.courses << [intro, c, js, react]
    track_frontend.courses << [intro, ui, js, react]
    track_rubyrails.courses << [intro, ruby, js, rails]
    track_rubyreact.courses << [intro, ruby, js, react]
    track_fidgetech.courses << [fidgetech_intro, fidgetech_c, fidgetech_js, fidgetech_react]
    track_workshops.courses << [workshops]
    track_internship_job_search.courses << [internship_job_search]
    track_archived.courses << [css, design, java, android, net, php, drupal, ember, online, java_old]
  end

  def down
    Track.destroy_all
  end
end
