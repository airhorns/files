require 'open-uri'
class Downloadable
  include DataMapper::Resource

  property :id, Serial
  property :type, Discriminator

  has n, :releases
  accepts_nested_attributes_for :releases

  class << self
    def download_remote_image(url)
      io = open(URI.parse(url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    end


    def build_from_path(path)
      if instance = self.identify(path)
        release = Release.new(:quality => self.guess_quality(path))
        
        if File.directory?(path)
          Dir.glob(File.join(path, "**", "*")).each do |f|
            release.files << path unless File.directory?(f)
          end
        else
          release.files << path
        end

        instance.releases << release
        return instance
      else
        return false
      end
    end
  end
end
