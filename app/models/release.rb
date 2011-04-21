class Release
  include Mongoid::Document

  embedded_in :downloadable
  field :quality, type: String
  field :confirmed, type: Boolean, default: false

  include Redis::Objects
  set :files

  after_save :add_files_to_cache!
  
  def add_files_to_cache!
    self.files.each do |f|
      FileCache.add_path!(f)
    end
  end

  def as_json(options = nil)
    options ||= {}
    options[:methods] = Array(options[:methods]).push(:files)
    super(options)
  end
end
