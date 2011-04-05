namespace :files do
  desc "Build up the Redis file system cache"
  task :build => :environment do
    count = FileCache.build!
    puts "#{count} files touched."
  end
end
