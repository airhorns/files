require 'redis/set'

module FileCache
  class << self
    def all
      Redis::Set.new('all_files')
    end

    def below(path)
      Redis::Set.new("files_#{dir_path(path)}")
    end

    def rebuild!
      self.clear!
      # Do the first step so the root path isnt added to the set
      Dir.glob(File.join(Files::Config.files_path, "*")).inject(0) do |acc, f|
        acc += self.add_path!(f)
        acc
      end
    end
    
    def add_path!(path, count = 0)
      if File.directory?(path)
        path = dir_path(path)
        # Remove the old set from the all set
        dir_set = "files_#{path}"
        $redis.sdiffstore("all_files", "all_files", dir_set)
        $redis.del(dir_set)
        Dir.glob(File.join(path, "*")).each do |f|
          count += self.add_path!(f)
        end
      end
      count += 1
      $redis.sadd("files_#{dir_path(File.dirname(path))}", path)
      $redis.sadd("all_files", path)
      return count
    end

    def directory?(path)
      #$redis.exists("files_" + File.join(path, ""))
      path[-1] == "/"
    end

    def all_underneath(path)
      s = []
      q = [path]
      until q.empty?
        contents = self.below(q.pop).to_a
        s.concat contents
        q.concat contents.select {|x| self.directory?(x)}
      end
      s
    end

    def all_immediately_underneath(path)
      self.below(path).to_a
    end

    def clear!
      self.all.clear
      $redis.keys("files_*").each do |k|
        $redis.del(k)
      end
    end

    def dir_path(path)
      File.join(path, "")
    end
  end
end
