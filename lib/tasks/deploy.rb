task :deploy do
  require 'heroku-headless'
  HerokuHeadless::Deployer.deploy 'learnhowtoprogram'
end
