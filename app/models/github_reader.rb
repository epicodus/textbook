class GithubReader
  def initialize(layout_file_path)
    begin
      @layout_file_path = layout_file_path
      @layout_filename = layout_file_path.match(/(layout.*)/)[1]
      @repo = layout_file_path.match(/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}\/(.*)\/blob\/master/)[1]
      @directory = layout_file_path.match(/\/blob\/master\/(.*)\/layout/)[1]
    rescue NoMethodError => e
      raise GithubError, "Invalid layout file path #{layout_file_path}"
    end
  end

  def parse_layout_file
    layout_file = read_file(filename: @layout_filename)
    if is_valid?(layout_file)
      lessons_params = YAML.load(layout_file)
      lessons_params.each do |params|
        params[:lessons].each do |lesson|
          filename = lesson[:filename]
          repo = lesson[:repo] || @repo
          directory = lesson[:directory] || @directory
          lesson[:content] = read_file(filename: filename, repo: repo, directory: directory)
          lesson[:cheat_sheet] = read_file(filename: filename.sub('.md', '_cheat.md'), repo: repo, directory: directory)
          lesson[:teacher_notes] = read_file(filename: filename.sub('.md', '_teacher.md'), repo: repo, directory: directory)
          lesson[:work_type] = filename.downcase.include?('classwork') || filename.downcase.include?('independent_project') ? 'exercise' : 'lesson'
          lesson[:github_path] = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{directory}/#{filename}"
        end
      end
      lessons_params
    else
      raise GithubError, "Invalid layout file #{@layout_file_path}"
    end
  end

  def self.update_sections(repo:, directories:)
    directories.each do |directory|
      sections = Section.where('layout_file_path LIKE ?', "%https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{directory}/layout%")
      sections.each do |section|
        section.try(:build_section)
      end
    end
  end

private

  def read_file(filename:, repo: @repo, directory: @directory)
    begin
      path = directory == '/' ? "/#{filename}" : "/#{directory}/#{filename}"
      client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}", path: path, accept: 'application/vnd.github.3.raw')
    rescue Faraday::Error => e
      raise GithubError, e.message
    rescue Octokit::NotFound => e
      raise GithubError, "File not found: #{repo}/#{directory}/#{filename}" unless filename.include?('_cheat.md') || filename.include?('_teacher.md')
    end
  end

  def is_valid?(layout_file)
    begin
      params = YAML.load(layout_file)
    rescue Psych::SyntaxError
      raise GithubError, "Syntax error in layout file #{@layout_file_path}"
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
