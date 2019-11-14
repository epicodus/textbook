web: bundle exec puma -C config/puma.rb
worker: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 QUEUE=* bundle exec rake resque:work
