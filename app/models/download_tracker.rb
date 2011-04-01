module DownloadTracker
  include Redis::Objects
  
  set :downloads
  
  def downloaded?(path)
    self.downloads.contains?(path)
  end

  def undownloaded?(path)
    !downloaded?(path)
  end

end
