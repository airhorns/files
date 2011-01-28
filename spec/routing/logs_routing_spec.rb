require "spec_helper"

describe LogsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/logs" }.should route_to(:controller => "logs", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/logs/new" }.should route_to(:controller => "logs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/logs/1" }.should route_to(:controller => "logs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/logs/1/edit" }.should route_to(:controller => "logs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/logs" }.should route_to(:controller => "logs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/logs/1" }.should route_to(:controller => "logs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/logs/1" }.should route_to(:controller => "logs", :action => "destroy", :id => "1")
    end

  end
end
