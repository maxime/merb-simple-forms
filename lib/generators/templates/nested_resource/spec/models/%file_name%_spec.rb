require File.dirname(__FILE__) + '/../spec_helper'

describe <%= class_name %> do
  before :each do
    @<%=name%> = <%= class_name %>.new
  end
  
  it "should have the <%= attributes.keys.join(", ") %> columns" do
    <%= attributes.keys.collect{|k| k.intern}.inspect %>.each do |column|
      @<%= name %>.attributes.keys.should include(column)
    end
  end
  
  it "should have a belongs_to association with <%= human_parent_name %>" do
    <%= class_name %>.relationships.should be_has_key(:<%= parent %>)
    <%= class_name %>.relationships[:<%= parent %>].parent_model.should == <%= parent_class_name %>
  end
  
  it "should have more specs"
  
  # Validation specs
  # Associations specs
  # Any kind of specs...
end