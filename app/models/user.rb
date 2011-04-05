class User < ActiveRedis
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  property :id, Serial
  
  # Redis containers for downloaded files
  include Redis::Objects
  
  set :downloads
  
  def downloaded?(path)
    # Normalize for directories with or without trailing slashes
    if File.directory?(path)
      path = File.join(path, "")
    end

    self.downloads.member?(path)
  end

  def undownloaded?(path)
    !downloaded?(path)
  end

  def mark_as_downloaded(path, downloaded = true)
    if File.directory?(path)
      FileCache.all_underneath(path).each do |f|
        mark_path(f, downloaded)
      end
    end
    mark_path(path, downloaded)

    # Set state of containing directories
    until (path = File.dirname(path)) == Files::Config.files_path 
      if FileCache.all_immediately_underneath(path).all? {|f| self.downloaded?(f) }
        mark_path(path, true)
      else
        mark_path(path, false)
      end
    end
    return downloaded
  end

  private
  def mark_path(path, state)
    # Normalize for directories with or without trailing slashes
    if File.directory?(path)
      path = File.join(path, "")
    end
    if state
      downloads.add path
    else
      downloads.delete path
    end
  end
end
