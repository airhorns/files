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
    self.downloads.member?(path)
  end

  def undownloaded?(path)
    !downloaded?(path)
  end

  def mark_as_downloaded(path, downloaded = true)
    puts "Marking #{path} as downloaded"
    if downloaded
      downloads.add path
    else
      downloads.delete path
    end
  end
end
