# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork', :wait => 60 do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch('spec/spec_helper.rb')
end

guard 'rspec', :version => 2, :drb => true do
  watch(/^spec\/(.*)_spec.rb/)
  watch(/^spec\/spec_helper.rb/)                        { "spec" }
  watch(/^app\/(.*)\.rb/)                               { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^config\/routes.rb/)                           { "spec/routing" }
  watch(/^app\/controllers\/application_controller.rb/) { "spec/controllers" }
  watch(/^spec\/factories.rb/)                          { "spec/models" }
end

guard 'coffeescript', :output => 'public/javascripts' do
  watch(/^client_app\/(.*)\.coffee/)
end

guard 'coffeescript', :output => 'spec/javascripts' do
  watch(/^spec\/coffeescripts\/(.*)\.coffee/)
end

guard 'compass' do
  watch(/^app\/stylesheets\/(.*)\.s[ac]ss/)
end

