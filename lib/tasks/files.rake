namespace :files do
  desc "Build up the Redis file system cache"
  task :build => :environment do
    count = FileCache.build!
    puts "#{count} files touched."
  end

  desc "Used by transmission to a folder to the system"
  task :add_from_transmission => :environment do
    dir = ENV['TR_TORRENT_DIR']
    if /#{File.join(Files::Config.files_path, Files::Config.movies_dir)}/ =~ dir
      if movie = Movie.build_from_path(dir)
        movie.save!
      else
        puts "Couldn't save movie at path #{dir}!"
      end
    end
  end

  desc "Used by users to scan a folder into the system"
  task :add_folder, :path, :needs => :environment do |t, args|
    puts "Searching #{args.path}"
    items = Dir.glob(File.join(args.path, "*"))[0..10]
    items.each do |dir|
      puts "Looking at #{dir}."
      if /#{File.join(Files::Config.files_path, Files::Config.movies_dir)}/ =~ dir
        if movie = Movie.build_from_path(dir)
          movie.save
        else
          puts "Couldn't save movie at path #{dir}!"
        end
      end
    end
  end

  desc "Used by users to scan a folder into the system"
  task :test_movies, :needs => :environment do |t|
    Movie.destroy
    path = "/Users/hornairs/Sites/files/files/movies"
    puts "Searching #{path}"
    items = Dir.glob(File.join(path, "*"))[0..10]
    items.each do |dir|
      puts "Looking at #{dir}."
      if /#{File.join(Files::Config.files_path, Files::Config.movies_dir)}/ =~ dir
        if movie = Movie.build_from_path(dir)
          movie.save
        else
          puts "Couldn't save movie at path #{dir}!"
        end
      end
    end
  end
  
end
