class SystemValue < ActiveRedis
  property :identifier, String, :unique => true, :index => true
  property :value, String
  def self.[](id)
    self.first(:identifier => id)
  end

  def self.[]=(id, value)
    if row = self.first(:identifier => id)
      row.update(:value => value)
    else
      raise "Couldn't find SystemValue with key #{id}"
    end
  end
end
