require 'open-uri'
class Downloadable
  include Mongoid::Document

  embeds_many :releases
  
  scope :unconfirmed, where("releases.confirmed" => false)
  scope :confirmed, where("releases.confirmed" => true)

  class << self
    def download_remote_image(url)
      io = open(URI.parse(url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    end
    
    def poly_create_from_path(path)
      klass = case path    
        when /#{File.join(Files::Config.files_path, Files::Config.movies_dir)}/ then Movie
        else Downloadable
      end
      if instance = klass.build_from_path(dir)
        if instance.save
          puts "Saved."
        else
          puts "Error saving downloadable!"
          puts instance.errors
        end
      else
        puts "Couldn't save downloadable at path #{dir}!"
      end
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
        instance
      else
        false
      end
    end

    def guess_quality(path)
      "Unknown"
    end
  end

  def name
    self
  end

  def as_json(options = nil)
    options ||= {}    
    options[:methods] = Array(options[:methods]).push(:name)
    super(options)
  end
end
