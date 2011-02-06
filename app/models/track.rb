class Track < ActiveRecord::Base
  set_table_name "track"
  belongs_to :album, :through => :album_tracks
end
