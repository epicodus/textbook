class Github
  def self.get_content(github_path)
    repo = github_path.match(/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}\/(.*)\/blob\/master/)[1]
    file = github_path.match(/\/blob\/master\/(.*)/)[1]
    begin
      { content: client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}", path: "/#{file}", accept: 'application/vnd.github.3.raw') }
    rescue Faraday::Error => e
      { error: true }
    rescue Octokit::NotFound => e
      { error: true }
    end
  end

  def self.update_lessons(params)
    update_modified_lessons(params[:repo], params[:modified]) if params[:modified].try(:any?)
    update_removed_lessons(params[:repo], params[:removed]) if params[:removed].try(:any?)
  end

  def self.build_section(section)
    github_base_path = section.github_path.sub('/tree/', '/blob/').concat('/')
    layout_file = get_content(github_base_path + 'layout.md')[:content].gsub!("```\n", "")
    day_of_week = nil
    layout_file.each_line do |line|
      if line.include?(' ||| ')
        title, filename = line.split(' ||| ')
        section.lesson_sections << build_lesson(title: title, day_of_week: day_of_week, content_path: github_base_path + filename)
      else
        day_of_week = line.strip
      end
    end
  end

  def self.build_lesson(title:, day_of_week:, content_path:)
    content = get_content(content_path)[:content]
    cheat_sheet = get_content(content_path.sub('.md', '_cheat.md'))[:content]
    teacher_notes = get_content(content_path.sub('.md', '_teacher.md'))[:content]
    work_type = content_path.downcase.include?('classwork') || content_path.downcase.include?('independent_project') ? 'exercise' : 'lesson'
    LessonSection.new(work_type: work_type, day_of_week: day_of_week, lesson: Lesson.create(name: title, content: content, cheat_sheet: cheat_sheet, teacher_notes: teacher_notes, public: true))
  end

  private_class_method def self.update_modified_lessons(repo, files)
    files.each do |file|
      lesson = Lesson.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      if lesson
        updated_content = client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}", path: "/#{file}", accept: 'application/vnd.github.3.raw')
        lesson.update_columns(content: updated_content)
      end
    end
  end

  private_class_method def self.update_removed_lessons(repo, files)
    files.each do |file|
      lesson = Lesson.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      lesson.update_columns(public: false) if lesson
    end
  end

  private_class_method def self.client
    headers = { Authorization: "Bearer #{new_jwt_token}", Accept: 'application/vnd.github.machine-man-preview+json' }
    access_tokens_url = "/installations/#{ENV['GITHUB_INSTALLATION_ID']}/access_tokens"
    access_tokens_response = Octokit::Client.new.post(access_tokens_url, headers: headers)
    access_token = access_tokens_response[:token]
    Octokit::Client.new(access_token: access_token)
  end

  private_class_method def self.new_jwt_token
    private_pem = ENV['GITHUB_APP_PEM']
    private_key = OpenSSL::PKey::RSA.new(private_pem)
    payload = { iat: Time.now.to_i, exp: 9.minutes.from_now.to_i, iss: ENV['GITHUB_APP_ID'] }
    JWT.encode(payload, private_key, "RS256")
  end
end
