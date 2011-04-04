require 'redis/set'

module FileCache
  class << self
    def all
      Redis::Set.new('all_files')
    end

    def below(path)
      Redis::Set.new("files_#{path}")
    end

    def build
      q = [Files::Config.files_path]
      all = self.all
      all.clear
      count = 0
      until q.empty?
        path = q.pop
        count += 1
        path_set = Redis::Set.new("files_#{path}")
        path_set.clear
        Dir.glob(File.join(path, "*")).each do |f|
          if File.directory?(f)
            f += "/"
            q << f
          end
          all << f
          path_set << f
        end
      end
      return count
    end

    def directory?(path)
      $redis.exists(File.join(path, ""))
    end
  end
end
