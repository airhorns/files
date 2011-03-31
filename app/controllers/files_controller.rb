class FilesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  
  # List info about one file
  def get
    filename = File.join(Files::Config.files_path, params[:path], '.', params[:ext])
    respond_with filename
  end

  # List files in a dir
  def index
    contents = Dir.glob(File.join(Files::Config.files_path, params[:path] || "", "*"))

    agg = contents.inject({:files => [], :directories => []}) do |acc, content|
      if File.directory?(content)
        acc[:directories].push directory_details(content) 
      else
        acc[:files].push file_details(content)
      end
      acc
    end
    respond_with agg
  end
  
  private

  def strip_path(path)
    path[Files::Config.files_path.length..-1]
  end

  def file_details(path)
    f = File.new(path)
    {:modified => f.mtime, :size => readable_file_size(f.size), :path => strip_path(f.path)}
  end
  
  def directory_details(path)
    f = File.new(path)
    {:modified => f.mtime, :size => "--", :path => strip_path(f.path)}
  end

  GIGA_SIZE = 1073741824.0
  MEGA_SIZE = 1048576.0
  KILO_SIZE = 1024.0

  # Return the file size with a readable style.
  def readable_file_size(size, precision=2)
    case
      when size == 1 then "1 byte"
      when size < KILO_SIZE then "%d bytes" % size
      when size < MEGA_SIZE then "%.#{precision}f KB" % (size / KILO_SIZE)
      when size < GIGA_SIZE then "%.#{precision}f MB" % (size / MEGA_SIZE)
      else "%.#{precision}f GB" % (size / GIGA_SIZE)
    end
  end
end