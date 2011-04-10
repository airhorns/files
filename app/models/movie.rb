class Movie < Downloadable
  property :title, String, :required => true
  property :year, String, :required => true
  property :imdb_id, String, :required => true
  property :imdb_rating, Float
  property :synopsis, Text
  property :tagline, String
  property :runtime, String
  property :poster, String

  mount_uploader :poster, MoviePosterUploader, :mount_on => :poster
  
  class << self
  
  def identify(path)
    if movie = MovieSearcher.find_by_download(path.encode("UTF-8"))
      return self.new_from_imdb(movie)
    else
      return false
    end
  end

  def new_from_imdb(imdb)
    Movie.new({
      :title => imdb.title,
      :year => imdb.year,
      :imdb_id => imdb.imdb_id,
      :imdb_rating => imdb.rating,
      :synopsis => imdb.plot,
      :tagline => imdb.tagline,
      :remote_poster_url => imdb.poster_url
    })
  end

  def guess_quality(path)
    path = path.gsub(/\s|-|_|\./, '')
    # Super HD
    if /(1080p|1080i)/i.match(path)
      return "Super HD (#{$1})" 
    elsif /(720p|bluray|480i)/i.match(path)
      return "HD (#{$1})"
    elsif File.directory?(path) && Dir.glob(File.join(path, "**", "*.mkv")).length > 0
      return "HD"
    elsif /(dvdrip|dvdscr|divx|xvid|bdrip|cam|r5|ts)/i.match(path)
      return "SD (#{$1.upcase})"
    else
      return "Unknown"
    end
  end

  # Unused methods
  def get_imdb_from_nfo(path)
    Dir.glob(File.join(path, '*.{nfo,txt,rtf}')).each do |nfo|
      nfo = File.open(nfo, "rb").read
      if /imdb\.com\/title\/tt([0-9]+)/.match(nfo) 
        return $1
      end
    end
    return false
  end
    
  def get_title_from_filename(filename)
    title = File.basename(filename).gsub(/\/|(?:readinfo|readnfo|xvid|dvdrip|dvd rip|dvdscreener|screener|dvdscr|webrip|dvd|rls|limited|ac3|ts|fs|ws|subbed|unrated|internal|r5|bdrip|cd1|cd2|avi|wmv|xvid|divx|bluray|1080p|720p|1080i|480i|proper|dts|x\.264|x264|re.pack|rerepack).*|\[.+?\]|\*|\/$/i, '')
    title = title.gsub(/-[^\s]+?$/, '')
    title = title.gsub(/-|_|\./, ' ')
    return title.strip
  end 
  end
  
  def as_json(*args)
    if args.blank? || args.first.blank?
      args = [{}]
    end
    args.first.merge!({:exclude => [:poster, :type], :methods => [:releases]})
    super(*args).merge({ 
       :poster_url => self.poster.url, 
       :poster_thumb_url => self.poster.thumb.url
      })
  end
end
