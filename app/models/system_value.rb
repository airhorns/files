class SystemValue
  include Mongoid::Document
  field :identifier, type: String
  field :value, type: String

  def self.[](id)
    self.first(conditions: {identifier: id})
  end

  def self.[]=(id, value)
    if row = self[id]
      row.update(:value => value)
    else
      raise "Couldn't find SystemValue with key #{id}"
    end
  end
end
