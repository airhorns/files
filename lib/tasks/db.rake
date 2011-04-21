namespace :db do
  namespace :redis do
    desc "Reset the Redis DB."
    task :reset => :environment do
      $redis.flushdb
      Rake::Task["db:seed"].invoke
      count = FileCache.rebuild!
      puts "#{count} files touched in FileCache."
    end
  end
end
