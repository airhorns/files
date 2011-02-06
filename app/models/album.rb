class Album < ActiveRecord::Base
  set_table_name "album"

  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name =~ /^attributes/
      super
    end
  end

  belongs_to :artist
  has_many :tracks, :through => :album_tracks
end
