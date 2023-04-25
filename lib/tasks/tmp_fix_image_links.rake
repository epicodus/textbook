desc "fix images links"
task :tmp_fix_image_links => [:environment] do
  File.open('tmp/fix_image_links.csv', 'w') do |file|
    urls = generate_s3_urls
    unmatched = []
    Course.where(public: true).each do |course|
      course.sections.where(public: true).each do |section|
        section.lessons.where(public: true).each do |lesson|
          if lesson.content.include?("dropbox")
            route = "https://www.learnhowtoprogram.com#{Rails.application.routes.url_helpers.course_section_lesson_path(lesson.section.course, lesson.section, lesson)}"
            links = lesson.content.scan(/(\/\/(dl|www)\.dropbox.*?)\)/)
            links.each do |link|
              url = "http:" + link[0]
              filename = url.split("/").last.split("?").first
              filename = filename.gsub("%20", " ").gsub("%28", "(").gsub("%29", ")")
              matching_urls = find_s3_urls(urls, filename)
              if matching_urls.count == 1
                file.puts route
                file.puts "#{url}, #{matching_urls.first}"
                file.puts ''
              elsif matching_urls.count > 1
                file.puts ''
                file.puts route
                file.puts "Multiple URLs found for #{url}:"
                matching_urls.each { |matching_url| file.puts "  #{matching_url}" }
              else
                file.puts ''
                file.puts route
                file.puts "Unmatched: #{url}"
              end
            end
          end
        end
      end
    end
  end
end

def generate_s3_urls
  urls = {}
  s3_objects = JSON.parse(File.read('s3_contents.json'))
  s3_objects['Contents'].each do |content|
    key = content['Key']
    url = "https://learnhowtoprogram.s3.us-west-2.amazonaws.com/#{key}"
    urls[key] = url
  end
  urls
end

def find_s3_urls(urls, filename)
  matching_urls = urls.select { |key, _| key.split('/').last.downcase == filename.downcase }
  matching_urls.values
end
