class Movie < Downloadable

  property :id, Serial
  property :title, String, :required => true
  property :year, String, :required => true
  property :imdb_id, String, :required => true
  property :imdb_rating, Float
  property :synopsis, Text
  property :tagline, String
  
  class << self
  def identify(path)
    if File.directory?(path) and (imdb_id = get_imdb_from_nfo(path))
      movie = Imdb::Movie.new(imdb_id)
    else
      search = Imdb::Search.new(get_title_from_filename(path))
      movie = search.movies.first
    end
      
    if movie
      return self.new_from_imdb(movie)
    else
      return false
    end
  end

  def new_from_imdb(imdb)
  end
  
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
    title = File.basename(filename).gsub(/\/|(?:readinfo|readnfo|xvid|dvdrip|dvd rip|dvdscreener|screener|dvdscr|dvd|rls|limited|ac3|ts|fs|ws|subbed|unrated|internal|r5|bdrip|cd1|cd2|avi|wmv|xvid|divx|bluray|1080p|720p|1080i|480i|proper|dts|x\.264|x264|re.pack|rerepack).*|\[.+?\]|\*|\/$/i, '')
    title = title.gsub(/-[^\s]+?$/, '')
    title = title.gsub(/-|_|\./, ' ')
    return title.strip
  end 
  end
end
