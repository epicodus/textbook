COURSE_NAME = 'Introduction to Programming'

desc "export list of ALL images in a given course"
task :tmp_export_list_images => [:environment] do
  images = []
  lessons = Lesson.where_public.where(section: Section.where_public.where(course: Course.where(name: COURSE_NAME)))
  lessons.each do |lesson|
    if lesson.content.include? 'https://learnhowtoprogram.s3.us-west-2.amazonaws.com/'
      image_link_pattern = /https:\/\/learnhowtoprogram\.s3\.us-west-2\.amazonaws\.com\/(?:[^\/]+\/)+[^\/]+\.(?:png|gif|jpg|jpeg)/
      links = lesson.content.scan(image_link_pattern)
      images += links.map {|url| url.gsub('https://learnhowtoprogram.s3.us-west-2.amazonaws.com/', '')}
    end
  end
  puts images.uniq.sort
end
