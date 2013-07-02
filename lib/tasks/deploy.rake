task :deploy do
  require 'heroku-headless'
  HerokuHeadless.configure do |config|
    config.post_deploy_commands = ['rake db:migrate']
    config.restart_processes = true
  end
  exit HerokuHeadless::Deployer.deploy('learnhowtoprogram') ? 0 : 1
end
