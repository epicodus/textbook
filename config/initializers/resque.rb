if Rails.env == 'production'
  uri = URI.parse(ENV["REDIS_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Resque.redis = Redis.new(:host => 'localhost', :port => '6379', :password => ENV['REDIS_PASSWORD'])
end
