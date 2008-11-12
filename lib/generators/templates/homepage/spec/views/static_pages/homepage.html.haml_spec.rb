require File.dirname(__FILE__) + '/../../spec_helper'

describe "static_pages/homepage" do
  before(:each) do                    
    @controller = StaticPages.new(fake_request)
    @body = @controller.render(:homepage) 
  end
  
  it "should have a Homepage title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Homepage")}
  end
end