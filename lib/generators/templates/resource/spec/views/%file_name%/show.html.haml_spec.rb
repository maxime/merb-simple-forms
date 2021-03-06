require File.dirname(__FILE__) + '/../../spec_helper'

describe "<%= plural_name %>/show" do
  before(:each) do                    
    @controller = <%= controller_name %>.new(fake_request)
    @<%= name %> = <%= class_name %>.new(<%= generate_attributes %>)
    
    @controller.instance_variable_set(:@<%= name %>, @<%= name %>)
    @body = @controller.render(:show) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("<%= plural_human_name %>")}
  end

<% attributes.each_pair do |key, value| -%>
  it "should display the <%= key %>" do
    @body.should have_tag(:p, :id => "<%= key %>") {|p| p.should contain(@<%= name %>.<%= key %>.to_s)}
  end
<% end -%>
end