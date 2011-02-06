class Artist < ActiveRecord::Base
  set_table_name "artist"
  has_many :albums
end
