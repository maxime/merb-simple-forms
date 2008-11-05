require File.dirname(__FILE__) + '/../../spec_helper'

describe "<%= plural_name %>/index" do
  before(:each) do                    
    @controller = <%= controller_name %>.new(fake_request)
    
    @<%= parent %> = <%= parent_class_name %>.new(:id => 1)
    @controller.instance_variable_set(:@<%= parent %>, @<%= parent %>)
    
    @first_<%= name %> = <%= class_name %>.new(<%= generate_attributes %>)
    @first_<%= name %>.stub!(:<%= parent %>).and_return(@<%= parent %>)
    @second_<%= name %> = <%= class_name %>.new(<%= generate_attributes %>)
    @second_<%= name %>.stub!(:<%= parent %>).and_return(@<%= parent %>)
    
    @<%= plural_name %> = [@first_<%= name %>, @second_<%= name %>]
    
    @controller.instance_variable_set(:@<%= plural_name %>, @<%= plural_name %>)
    @body = @controller.render(:index) 
  end
  
  it "should display the <%= plural_human_name %> title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("<%= plural_human_name %>")}
  end
  
  it "should display the different <%= plural_human_name.downcase %>" do
<% attributes.each_pair do |key, value| %>
    @body.should have_tag(:tr, :id => "<%= name %>_#{@first_<%= name %>.id}").with_tag(:td, :class => '<%= key %>') do |td|
      td.should contain(@first_<%= name %>.<%= key %>.to_s)
    end
    @body.should have_tag(:tr, :id => "<%= name %>_#{@second_<%= name %>.id}").with_tag(:td, :class => '<%= key %>') do |td|
      td.should contain(@second_<%= name %>.<%= key %>.to_s)
    end
<% end -%>
  end
end