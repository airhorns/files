require 'spec_helper'

describe "logs/show.html.haml" do
  before(:each) do
    @log = assign(:log, stub_model(Log,
      :show_id => 1,
      :pre_recorded => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
