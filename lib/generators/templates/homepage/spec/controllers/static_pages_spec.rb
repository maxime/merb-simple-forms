require File.dirname(__FILE__) + '/../spec_helper'

describe StaticPages, "homepage" do
  it "should have a route from / GET" do
    request_to("/", :get).should route_to(StaticPages, :homepage)
  end
  
  it "should be successful" do
    dispatch_to(StaticPages, :homepage) do |controller|
      controller.stub!(:render)
    end.should be_successful
  end
  
  it "should render the template" do
    dispatch_to(StaticPages, :homepage) do |controller|
      controller.should_receive(:render).with(no_args)
    end    
  end
end