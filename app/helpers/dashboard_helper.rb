module DashboardHelper
  def asset_link_to(file)
    Files::Config.asset_host + file
  end
end
