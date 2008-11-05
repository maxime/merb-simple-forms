require File.dirname(__FILE__) + '/../../spec_helper'

describe "<%= plural_name %>/form" do
  before(:each) do                    
    @controller = <%= controller_name %>.new(fake_request)
    @<%= name %> = <%= class_name %>.new(<%= generate_attributes %>)
    @controller.instance_variable_set(:@<%= name %>, @<%= name %>)
    
    @body = @controller.render(:form) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Create")}
  end
  
  it "should display a form" do
    @body.should have_tag(:form, :action => '/<%= plural_name %>')
  end
  
<% attributes.each_pair do |key, value| -%>
  it "should have a <%= default_control(value) %> field for inputting the <%= key %>" do
    @body.should have_tag(:input, :type => '<%= default_control(value) %>', :id => '<%= name %>_<%= key %>')
  end
<% end -%>
end