class GithubCallback
  include ActiveModel::Model

  attr_reader :event

  def initialize(params)
    @event = params
  end

  def update_lessons
    update_modified_lessons
    update_removed_lessons
  end

  def push_to_master?
    branch == 'refs/heads/master'
  end

private

  def update_modified_lessons
    files_modified.each do |file|
      lesson = Lesson.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      if lesson
        updated_content = client.contents("#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}", path: "/#{file}", accept: 'application/vnd.github.3.raw')
        lesson.update(content: updated_content)
      end
    end
  end

  def update_removed_lessons
    files_removed.each do |file|
      lesson = Lesson.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      if lesson
        lesson.update(public: false)
      end
    end
  end

  def branch
    event['ref']
  end

  def repo
    event['repository']['name']
  end

  def files_modified
    event['commits'].map { |commit| commit['added'] + commit['modified'] }.flatten.uniq
  end

  def files_removed
    event['commits'].map { |commit| commit['removed'] }.flatten.uniq
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
    payload = { iat: Time.now.to_i, exp: 10.minutes.from_now.to_i, iss: ENV['GITHUB_APP_ID'] }
    JWT.encode(payload, private_key, "RS256")
  end
end
