class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :show_id
      t.datetime :start
      t.datetime :end
      t.boolean :pre_recorded
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
