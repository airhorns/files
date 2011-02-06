class LogLine < ActiveRecord::Base
  %w{artist album track}.each do |n|
    belongs_to "mb_#{n}".to_sym, :foreign_key => "gid", :class_name => n.capitalize
    validates_presence_of n.to_sym, :if => Proc.new {|line| line.send("mb_#{n}").nil? }
  end
  
  validates_presence_of :start_time, :duration, :canadian, :new_release, :french, :request
end
