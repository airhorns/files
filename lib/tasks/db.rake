namespace :db do
  desc "Reset the Redis DB."
  task :reset => :environment do
    $redis.flushdb
    Rake::Task["db:seed"].invoke
    count = FileCache.build!
    puts "#{count} files touched."
  end
end
