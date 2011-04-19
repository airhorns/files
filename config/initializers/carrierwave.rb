require 'carrierwave/orm/mongoid'
StringIO.class_eval { def original_filename; "stringio.txt"; end }

CarrierWave.configure do |config|
  config.permissions = 0666
  config.storage = :file
end
