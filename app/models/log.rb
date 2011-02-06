class Log < ActiveRecord::Base
  validates_presence_of :show_id, :start, :end, :pre_recorded

end
