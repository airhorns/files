module ApplicationHelper
  def asset_link_to(file)
    Files::Config.asset_host + web_path_of(file)
  end

  def web_path_of(file)
    file.gsub(Files::Config.files_path, "")
  end

  def disk_path_of(file)
    file
  end
end
