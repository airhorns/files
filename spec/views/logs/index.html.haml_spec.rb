require 'spec_helper'

describe "logs/index.html.haml" do
  before(:each) do
    assign(:logs, [
      stub_model(Log,
        :show_id => 1,
        :pre_recorded => false
      ),
      stub_model(Log,
        :show_id => 1,
        :pre_recorded => false
      )
    ])
  end

  it "renders a list of logs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
