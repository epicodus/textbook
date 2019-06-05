class GithubReader
  def self.parse_layout_file(github_path)
    repo, directory = parse_github_path(github_path)
    layout_file = read_file(repo: repo, directory: directory, filename: 'layout.md').gsub!("```\n", "")
    day_of_week = nil
    lessons_params = []
    layout_file.each_line do |line|
      if line.include?(' ||| ')
        title, filename = line.split(' ||| ')
        work_type = filename.downcase.include?('classwork') || filename.downcase.include?('independent_project') ? 'exercise' : 'lesson'
        content = read_file(repo: repo, directory: directory, filename: filename)
        cheat_sheet = read_file(repo: repo, directory: directory, filename: filename.sub('.md', '_cheat.md'))
        teacher_notes = read_file(repo: repo, directory: directory, filename: filename.sub('.md', '_teacher.md'))
        lessons_params << { day_of_week: day_of_week, work_type: work_type, title: title, content: content, cheat_sheet: cheat_sheet, teacher_notes: teacher_notes }
      else
        day_of_week = line.strip
      end
    end
    is_valid?(lessons_params) ? lessons_params : raise_error("Unable to parse layout file for repo #{repo}")
  end

  def self.update_sections(repo:, directories:)
    directories.each do |directory|
      section = Section.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/tree/master/#{directory}")
      section.try(:build_section)
    end
  end

  private_class_method def self.read_file(repo:, directory:, filename:)
    begin
      client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}", path: "/#{directory}/#{filename}", accept: 'application/vnd.github.3.raw')
    rescue Faraday::Error => e
      raise_error(e.message)
    rescue Octokit::NotFound => e
      raise_error(e.message) unless filename.include?('_cheat.md') || filename.include?('_teacher.md')
    end
  end

  private_class_method def self.parse_github_path(path)
    begin
      repo = path.match(/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}\/(.*)\/tree\/master/)[1]
      directory = path.match(/\/tree\/master\/(.*)/)[1]
    rescue NoMethodError => e
      raise_error("Invalid github path #{path}")
    end
    return repo, directory
  end

  private_class_method def self.is_valid?(lessons_params)
    lessons_params && lessons_params.all? { |params| params[:title] && params[:content] && params[:day_of_week] && params[:work_type] }
  end

  private_class_method def self.raise_error(message)
    raise GithubError, message
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
