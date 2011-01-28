require 'spec_helper'

describe "logs/new.html.haml" do
  before(:each) do
    assign(:log, stub_model(Log,
      :show_id => 1,
      :pre_recorded => false
    ).as_new_record)
  end

  it "renders new log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => logs_path, :method => "post" do
      assert_select "input#log_show_id", :name => "log[show_id]"
      assert_select "input#log_pre_recorded", :name => "log[pre_recorded]"
    end
  end
end
