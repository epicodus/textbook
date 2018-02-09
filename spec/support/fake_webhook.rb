class FakeWebhook
  def initialize(fixture:, host:, path:, port:)
    @fixture = fixture
    @host = host
    @path = path
    @port = port
    load_fixture
  end

  def send
    HTTParty.post("http://#{@host}:#{@port}/github_callbacks", headers: headers, body: JSON.generate(body))
  end

  private

  attr_accessor(
    :body,
    :connection,
    :fixture,
    :headers,
    :path,
    :session
  )

  def load_fixture
    fixture_json = JSON.parse(File.read("#{Rails.root}/spec/fixtures/#{fixture}"))
    @headers = fixture_json.fetch("headers")
    @body = fixture_json.fetch("body")
  end
end
