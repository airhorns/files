class CreateSystemValues < ActiveRecord::Migration
  def self.up
    create_table :system_values do |t|
      t.string :key, :unique => true
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :system_values
  end
end
