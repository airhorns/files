class Release
  include Mongoid::Document

  embedded_in :downloadable
  field :quality, type: String

  include Redis::Objects
  set :files
end
