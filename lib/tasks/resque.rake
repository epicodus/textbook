desc "Clear failed jobs"
task "resque:clear" => :environment do
  Resque::Failure.clear
end
