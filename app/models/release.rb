class Release
  include DataMapper::Resource
  include Redis::Objects

  property :id, Serial
  property :quality, String

  belongs_to :downloadable
  set :files

  def as_json(*args)
    if args.blank? || args.first.blank?
      args = {}
    end
    super(args)
  end
end
