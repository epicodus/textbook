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
    # update github-linked sections
    all_changed_directories = (params[:modified] + params[:removed]).map {|filename| filename.split('/').first}.uniq
    all_changed_directories.each do |directory|
      section = Section.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{params[:repo]}/tree/master/#{directory}")
      if section
        section.empty_section
        section.build_section
      else
        # throw error
      end
    end

    # modify lessons not part of github-linked sections
    update_modified_lessons(params[:repo], params[:modified]) if params[:modified].try(:any?)
    update_removed_lessons(params[:repo], params[:removed]) if params[:removed].try(:any?)
  end

  def self.parse_layout_file(github_path)
    github_base_path = github_path.sub('/tree/', '/blob/').concat('/')
    layout_file = get_content(github_base_path + 'layout.md')[:content].gsub!("```\n", "")
    day_of_week = nil
    lessons_params = []
    layout_file.each_line do |line|
      if line.include?(' ||| ')
        title, filename = line.split(' ||| ')
        content = get_content(github_base_path + filename)[:content]
        cheat_sheet = get_content(github_base_path + filename.sub('.md', '_cheat.md'))[:content]
        teacher_notes = get_content(github_base_path + filename.sub('.md', '_teacher.md'))[:content]
        work_type = filename.downcase.include?('classwork') || filename.downcase.include?('independent_project') ? 'exercise' : 'lesson'
        lessons_params << { day_of_week: day_of_week, work_type: work_type, title: title, content: content, cheat_sheet: cheat_sheet, teacher_notes: teacher_notes }
      else
        day_of_week = line.strip
      end
    end
    lessons_params
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
