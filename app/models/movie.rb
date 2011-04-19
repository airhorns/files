class Movie < Downloadable
  field :title, type: String
  field :year, type: String
  field :imdb_id, type: String
  field :imdb_rating, type: Float
  field :synopsis, type: String
  field :tagline, type: String
  field :runtime, type: String
  field :poster, type: String 

  mount_uploader :poster, MoviePosterUploader, :mount_on => :poster
  
  class << self
  
  # Takes a path and returns either a new or existing Movie representing
  # the files at that path.
  def identify(path)
    imdb = nil
    if imdb = MovieSearcher.find_by_download(path.encode("UTF-8"))
      if existing = Movie.first(conditions: {imdb_id: imdb.imdb_id})
        return existing
      else
        imdb = MovieSearcher.find_movie_by_id(imdb.imdb_id) # force get details
        return self.new_from_imdb(imdb)
      end
    else
      return false
    end
  end

  def new_from_imdb(imdb)
    m = Movie.new({
      :title => imdb.title,
      :year => imdb.year || imdb.release_date ? imdb.release_date.year : Time.now.year,
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
end
