require 'redis/set'

module FileCache
  class << self
    def all
      Redis::Set.new('all_files')
    end

    def below(path)
      Redis::Set.new("files_#{File.join(path,"")}")
    end

    def build!
      q = [Files::Config.files_path]
      self.clear!
      all = self.all
      count = 0
      until q.empty?
        path = q.pop
        count += 1
        path_set = Redis::Set.new("files_#{path}")
        path_set.clear
        Dir.glob(File.join(path, "*")).each do |f|
          if File.directory?(f)
            f = File.join(f, "") # All directory entries in the system have a trailing slash for recognition as a dir
            q << f
          end
          all.add f
          path_set.add f
        end
      end
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
  end
end
