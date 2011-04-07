class Release
  include DataMapper::Resource
  include Redis::Objects

  property :id, Serial
  property :quality, String

  belongs_to :downloadable
  set :files

end
