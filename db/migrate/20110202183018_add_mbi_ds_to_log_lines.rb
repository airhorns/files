class AddMbiDsToLogLines < ActiveRecord::Migration
  def self.up
    add_column :log_lines, :artist_mbid, :string
    add_column :log_lines, :album_mbid, :string
    add_column :log_lines, :song_mbid, :string
  end

  def self.down
    remove_column :log_lines, :song_mbid
    remove_column :log_lines, :album_mbid
    remove_column :log_lines, :artist_mbid
  end
end
