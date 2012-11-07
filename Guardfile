guard 'bundler' do
  watch('Gemfile')
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/routes.rb')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
  watch('spec/factories.rb')
end

guard 'rspec', :cli => "--drb" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/integration" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/integration/#{m[1]}_pages_spec.rb" }
  watch('spec/factories.rb')                          { "spec" }
end
