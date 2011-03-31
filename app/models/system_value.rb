class SystemValue < ActiveRecord::Base
  def self.[](key)
    self.find_by_key(key)
  end

  def self.[]=(key, value)
    self.find_by_key(key).update_attributes(:value => value)
  end
end
