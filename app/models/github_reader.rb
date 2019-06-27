class GithubReader
  def initialize(github_path)
    begin
      @repo = github_path.match(/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}\/(.*)\/tree\/master/)[1]
      @directory = github_path.match(/\/tree\/master\/(.*)/)[1]
    rescue NoMethodError => e
      raise GithubError, "Invalid github path #{github_path}"
    end
  end

  def parse_layout_file
    layout_file = read_file('layout.yaml')
    if is_valid?(layout_file)
      lessons_params = YAML.load(layout_file)
      lessons_params.each do |params|
        params[:lessons].each do |lesson|
          lesson[:content] = read_file(lesson[:filename])
          lesson[:cheat_sheet] = read_file(lesson[:filename].sub('.md', '_cheat.md'))
          lesson[:teacher_notes] = read_file(lesson[:filename].sub('.md', '_teacher.md'))
          lesson[:work_type] = lesson[:filename].downcase.include?('classwork') || lesson[:filename].downcase.include?('independent_project') ? 'exercise' : 'lesson'
        end
      end
      lessons_params
    else
      raise GithubError, "Invalid layout file for #{@repo}/#{@directory}"
    end
  end

  def self.update_sections(repo:, directories:)
    directories.each do |directory|
      section = Section.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/tree/master/#{directory}")
      section.try(:build_section)
    end
  end

private

  def read_file(filename)
    begin
      client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{@repo}", path: "/#{@directory}/#{filename}", accept: 'application/vnd.github.3.raw')
    rescue Faraday::Error => e
      raise GithubError, e.message
    rescue Octokit::NotFound => e
      raise GithubError, "File not found: #{@repo}/#{@directory}/#{filename}" unless filename.include?('_cheat.md') || filename.include?('_teacher.md')
    end
  end

  def is_valid?(layout_file)
    begin
      params = YAML.load(layout_file)
    rescue Psych::SyntaxError
      raise GithubError, "Syntax error in layout file for #{@repo}/#{@directory}"
    end
    params.any? && params.all? { |day_params| day_params.try(:key?, :day) && day_params.try(:key?, :lessons) && day_params[:lessons].any? && day_params[:lessons].all? { |lesson_params| lesson_params.try(:key?, :title) && lesson_params.try(:key?, :filename) } }
  end

  def client
    headers = { Authorization: "Bearer #{new_jwt_token}", Accept: 'application/vnd.github.machine-man-preview+json' }
    access_tokens_url = "/installations/#{ENV['GITHUB_INSTALLATION_ID']}/access_tokens"
    access_tokens_response = Octokit::Client.new.post(access_tokens_url, headers: headers)
    access_token = access_tokens_response[:token]
    Octokit::Client.new(access_token: access_token)
  end

  def new_jwt_token
    private_pem = ENV['GITHUB_APP_PEM']
    private_key = OpenSSL::PKey::RSA.new(private_pem)
    payload = { iat: Time.now.to_i, exp: 9.minutes.from_now.to_i, iss: ENV['GITHUB_APP_ID'] }
    JWT.encode(payload, private_key, "RS256")
  end
end
