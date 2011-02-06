class AlbumTrack < ActiveRecord::Base
  set_table_name "albumjoin"
  belongs_to :album
  belongs_to :track
end
