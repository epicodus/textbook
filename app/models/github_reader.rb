class GithubReader
  def initialize(path)
    begin
      @filename = File.basename(path)
      @directory = File.dirname(path).split('/blob/main/')[1] || '/'
      @repo = path.match(/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}\/(.*)\/blob\/main/)[1]
    rescue NoMethodError => e
      raise GithubError, "Invalid Github path"
    end
  end

  def parse_layout_file
    layout_file = read_file(filename: @filename)
    if is_valid?(layout_file)
      lessons_params = YAML.load(layout_file)
      lessons_params.each do |params|
        params[:lessons].each do |lesson|
          filename = lesson[:filename]
          repo = lesson[:repo] || @repo
          directory = lesson[:directory] || @directory
          path = directory == '/' ? "#{filename}" : "#{directory}/#{filename}"
          lesson[:work_type] = filename.downcase.include?('classwork') || filename.downcase.include?('independent_project') ? 'exercise' : 'lesson'
          lesson[:github_path] = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/main/#{path}"
        end
      end
      lessons_params
    else
      raise GithubError, "Invalid layout file"
    end
  end

  def pull_lesson
    lesson_params = {}
    lesson_params[:content] = read_file(filename: @filename)
    lesson_params[:cheat_sheet] = read_file(filename: @filename.sub('.md', '_cheat.md'))
    lesson_params[:teacher_notes] = read_file(filename: @filename.sub('.md', '_teacher.md'))
    lesson_params[:video_id] = read_file(filename: @filename.sub('.md', '_video.md')).try(:strip)
    lesson_params
  end

private

  def read_file(filename:, repo: @repo, directory: @directory)
    begin
      path = directory == '/' ? "/#{filename}" : "/#{directory}/#{filename}"
      client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}", path: path, accept: 'application/vnd.github.3.raw')
    rescue Faraday::Error => e
      raise GithubError, e.message
    rescue Octokit::NotFound => e
      raise GithubError, "File not found: #{repo}/#{directory}/#{filename}" unless filename.include?('_cheat.md') || filename.include?('_teacher.md') || filename.include?('_video.md')
    end
  end

  def is_valid?(layout_file)
    begin
      params = YAML.load(layout_file)
    rescue Psych::SyntaxError
      raise GithubError, "Syntax error in layout file"
    end
    params.any? && params.all? { |day_params| day_params.try(:key?, :day) && day_params.try(:key?, :lessons) && day_params[:lessons].any? && day_params[:lessons].all? { |lesson_params| lesson_params.try(:key?, :title) && lesson_params.try(:key?, :filename) } }
  end

  def client
    unless @client
      headers = { Authorization: "Bearer #{new_jwt_token}", Accept: 'application/vnd.github.machine-man-preview+json' }
      access_tokens_url = "https://api.github.com/app/installations/#{ENV['GITHUB_INSTALLATION_ID']}/access_tokens"
      access_tokens_response = Octokit::Client.new.post(access_tokens_url, headers: headers)
      access_token = access_tokens_response[:token]
      @client = Octokit::Client.new(access_token: access_token)
    end
    @client
  end

  def new_jwt_token
    private_pem = ENV['GITHUB_APP_PEM']
    private_key = OpenSSL::PKey::RSA.new(private_pem)
    payload = { iat: Time.now.to_i, exp: 9.minutes.from_now.to_i, iss: ENV['GITHUB_APP_ID'] }
    JWT.encode(payload, private_key, "RS256")
  end
end
