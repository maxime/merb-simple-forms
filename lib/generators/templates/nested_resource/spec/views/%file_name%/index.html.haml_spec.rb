require File.dirname(__FILE__) + '/../../spec_helper'

<% parents.each do |parent| -%>
describe "<%= plural_name %>/index, <%= parent %> as parent" do
  before(:each) do                    
    @controller = <%= controller_name %>.new(fake_request)
    
    <%= parent_instance_variable_name %> = <%= parent_class_name(parent) %>.new(:id => 1)
    @controller.instance_variable_set(:<%= parent_instance_variable_name %>, <%= parent_instance_variable_name %>)
    
    @first_<%= name %> = <%= class_name %>.new(<%= generate_attributes %>)
    @first_<%= name %>.stub!(:<%= parent %>).and_return(<%= parent_instance_variable_name %>)
    @second_<%= name %> = <%= class_name %>.new(<%= generate_attributes %>)
    @second_<%= name %>.stub!(:<%= parent %>).and_return(<%= parent_instance_variable_name %>)
    
    @<%= plural_name %> = [@first_<%= name %>, @second_<%= name %>]
    
    @controller.instance_variable_set(:@<%= plural_name %>, @<%= plural_name %>)
    @body = @controller.render(:index) 
  end
  
  it "should display the <%= plural_human_name %> title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("<%= plural_human_name %>")}
  end
  
  it "should display the different <%= plural_human_name.downcase %>" do
<% attributes.each_pair do |key, value| %>
    @body.should have_tag(:tr, :id => "<%= name %>_#{@first_<%= name %>.id}") {|tr| tr.should contain(@first_<%= name %>.<%= key %>.to_s) }
    @body.should have_tag(:tr, :id => "<%= name %>_#{@second_<%= name %>.id}") {|tr| tr.should contain(@second_<%= name %>.<%= key %>.to_s) }
<% end -%>
  end
end

<% end -%>