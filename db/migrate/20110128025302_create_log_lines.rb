class CreateLogLines < ActiveRecord::Migration
  def self.up
    create_table :log_lines do |t|
      t.time :start_time
      t.time :duration
      t.string :type
      t.string :artist
      t.string :album
      t.string :song
      t.string :description
      t.string :category
      t.boolean :canadian
      t.boolean :new_release
      t.boolean :french
      t.boolean :request

      t.timestamps
    end
  end

  def self.down
    drop_table :log_lines
  end
end
