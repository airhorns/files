require 'spec_helper'

describe "logs/edit.html.haml" do
  before(:each) do
    @log = assign(:log, stub_model(Log,
      :show_id => 1,
      :pre_recorded => false
    ))
  end

  it "renders the edit log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => log_path(@log), :method => "post" do
      assert_select "input#log_show_id", :name => "log[show_id]"
      assert_select "input#log_pre_recorded", :name => "log[pre_recorded]"
    end
  end
end
