class FakeWebhook
  def initialize(fixture:, host:, path:, port:)
    @fixture = fixture
    @host = host
    @path = path
    @port = port

    load_fixture
    construct_connection
  end

  def send
    connection.post do |request|
      request.url path
      request.headers = headers
      request.body = JSON.generate(body)
    end
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

  def construct_connection
    @connection = HTTParty.get("http://#{@host}:#{@port}")
  end

  def fixture_path
    "#{Rails.root}/spec/fixtures/#{fixture}"
  end

  def load_fixture
    fixture_json = JSON.parse(File.read(fixture_path))

    @headers = fixture_json.fetch("headers")
    @body = fixture_json.fetch("body")
  end
end
