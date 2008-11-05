require File.dirname(__FILE__) + '/../spec_helper'

describe <%= controller_name %>, "index action" do
  before :each do
    @<%= parent %> = mock('<%= parent %>')
    <%= parent_class_name %>.stub!(:get).and_return(@<%= parent %>)
    
    @<%= plural_name %> = mock('<%= plural_name %>')
    @<%= parent %>.stub!(:<%= plural_name %>).and_return(@<%= plural_name %>)
  end
  
  def do_index
    dispatch_to(<%= controller_name %>, :index, :<%= parent %>_id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %> GET" do
    request_to('/<%= plural_parent %>/1/<%= plural_name %>', :get).should route_to(<%= controller_name %>, :index)
  end
  
  it "should be successful" do
    do_index.should be_successful
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_index
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_index }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the <%= human_name.downcase %>s from the database" do
    @<%= parent %>.should_receive(:<%= plural_name %>).with(no_args).and_return(@<%= plural_name %>)
    do_index
  end
  
  it "should render the <%= human_name.downcase %>s" do
    do_index do |controller|
      controller.should_receive(:display).with(@<%= plural_name %>)
    end
  end
  
  it "should assign the <%= human_name.downcase %>s to the view" do
    do_index.assigns(:<%= plural_name %>).should == @<%= plural_name %>
  end
end

describe <%= controller_name %>, "show action" do
  before :each do
    @<%= parent %> = mock('<%= parent %>')
    <%= parent_class_name %>.stub!(:get).and_return(@<%= parent %>)
    
    @<%= plural_name %> = mock('<%= plural_name %>')
    @<%= parent %>.stub!(:<%= plural_name %>).and_return(@<%= plural_name %>)
    
    @<%= name %> = mock('<%= name %>')
    @<%= plural_name %>.stub!(:get).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %>/2 GET" do
    request_to('/<%= plural_parent %>/1/<%= plural_name %>/2', :get).should route_to(<%= controller_name %>, :show)
  end
  
  def do_show
    dispatch_to(<%= controller_name %>, :show, :<%= parent %>_id => 1, :id => 2) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_show.should be_successful
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_show
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the <%= human_name.downcase %> from the database" do
    @<%= parent %>.should_receive(:<%= plural_name %>).and_return(@<%= plural_name %>)
    @<%= plural_name %>.should_receive(:get).with("2").and_return(@<%= name %>)
    do_show
  end
  
  it "should raise NotFound if the <%= human_name.downcase %> isn't found" do
    @<%= plural_name %>.stub!(:get).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the <%= human_name.downcase %> for the view" do
    do_show.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should display the <%= name %>" do
    do_show do |controller|
      controller.should_receive(:display).with(@<%= name %>)
    end
  end
end

describe <%= controller_name %>, "new action" do
  before :each do
    @<%= parent %> = mock('<%= parent %>')
    <%= parent_class_name %>.stub!(:get).and_return(@<%= parent %>)
    
    @<%= name %> = mock("<%= name %>")
    <%= class_name %>.stub!(:new).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %>/new GET" do
    request_to("/<%= plural_parent %>/1/<%= plural_name %>/new", :get).should route_to(<%= controller_name %>, :new)
  end
  
  def do_new
    dispatch_to(<%= controller_name %>, :new, :<%= parent %>_id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_new.should be_successful
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_new
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_new }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should create a new <%= human_name.downcase %> object" do
    <%= class_name %>.should_receive(:new).with(no_args).and_return(@<%= name %>)
    do_new
  end
  
  it "should assigns the <%= human_name.downcase %> object for the view" do
    do_new.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should render the <%= human_name.downcase %>" do
    do_new do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
end

describe <%= controller_name %>, "edit action" do
  before :each do
    @<%= parent %> = mock('<%= parent %>')
    <%= parent_class_name %>.stub!(:get).and_return(@<%= parent %>)
    
    @<%= plural_name %> = mock('<%= plural_name %>')
    @<%= parent %>.stub!(:<%= plural_name %>).and_return(@<%= plural_name %>)

    @<%= name %> = mock("<%= name %>")
    @<%= plural_name %>.stub!(:get).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %>/2/edit GET" do
    request_to("/<%= plural_parent %>/1/<%= plural_name %>/2/edit", :get).should route_to(<%= controller_name %>, :edit)
  end
  
  def do_edit
    dispatch_to(<%= controller_name %>, :edit, :<%= parent %>_id => 1, :id => 2) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_edit.should be_successful
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_edit
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the <%= human_name.downcase %> object" do
    @<%= parent %>.should_receive(:<%= plural_name %>).with(no_args).and_return(@<%= plural_name %>)
    @<%= plural_name %>.should_receive(:get).with("2").and_return(@<%= name %>)
    do_edit
  end
  
  it "should raise NotFound if the <%= human_name.downcase %> object isn't found" do
    @<%= plural_name %>.stub!(:get).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the <%= human_name.downcase %> object for the view" do
    do_edit.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should render the <%= human_name.downcase %>" do
    do_edit do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
end

describe <%= controller_name %>, 'create action' do
  before :each do
    @<%= parent %> = <%= parent_class_name %>.new
    @<%= parent %>.stub!(:id).and_return("1")
    <%= parent_class_name %>.stub!(:get).with("1").and_return(@<%= parent %>)
    
    @<%= name %> = <%= class_name %>.new
    @<%= name %>.stub!(:save).and_return(true)
    @<%= name %>.stub!(:id).and_return(2)
    <%= class_name %>.stub!(:new).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %> POST" do
    request_to("/<%= plural_parent %>/1/<%= plural_name %>", :post).should route_to(<%= controller_name %>, :create)
  end
  
  def attributes
    {"name" => "Expenses"}
  end
  
  def do_create
    dispatch_to(<%= controller_name %>, :create, :<%= parent %>_id => 1, :<%= name %> => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_create
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_create }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should create a new <%= human_name.downcase %> object" do
    <%= class_name %>.should_receive(:new).with(attributes).and_return(@<%= name %>)
    do_create
  end
  
  it "should set the <%= parent %>" do
    @<%= name %>.should_receive(:<%= parent %>=).with(@<%= parent %>)
    do_create
  end
  
  it "should try to save the <%= human_name.downcase %>" do
    @<%= name %>.should_receive(:save).with(no_args)
    do_create
  end
  
  it "should redirect to the newly created <%= human_name.downcase %> if successful" do
    do_create.should redirect_to(resource(@<%= parent %>, @<%= name %>), :message => {:notice => "<%= human_name %> was successfully created"})
  end
  
  it "should render the form if not successful" do
    @<%= name %>.stub!(:save).and_return(false)
    do_create do |controller|
      controller.should_receive(:render).with(:form)
    end.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should assign the <%= human_name.downcase %> to the view" do
    do_create.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should assign the country to the view" do
    do_create.assigns(:country).should == @country
  end
end

describe <%= controller_name %>, 'update' do
  before :each do
    @<%= parent %> = <%= parent_class_name %>.new(:id => "1")
    <%= parent_class_name %>.stub!(:get).with("1").and_return(@<%= parent %>)
  
    @<%= plural_name %> = mock("<%= plural_name %>")
    @<%= parent %>.stub!(:<%= plural_name %>).and_return(@<%= plural_name %>)
  
    @<%= name %> = <%= class_name %>.new(:id => "2")
    @<%= plural_name %>.stub!(:get).and_return(@<%= name %>)
    
    @<%= name %>.stub!(:update_attributes).and_return(true)
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %>/2 PUT" do
    request_to("/<%= plural_parent %>/1/<%= plural_name %>/2", :put).should route_to(<%= controller_name %>, :update)
  end
  
  def attributes
    {"name" => "Expenses"}
  end
  
  def do_update
    dispatch_to(<%= controller_name %>, :update, :<%= parent %>_id => 1, :id => 2, :<%= name %> => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_update
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the <%= human_name.downcase %> from the database" do
    @<%= parent %>.should_receive(:<%= plural_name %>).and_return(@<%= plural_name %>)
    @<%= plural_name %>.should_receive(:get).and_return(@<%= name %>)
    do_update
  end
  
  it "should raise NotFound if the <%= human_name.downcase %> isn't found" do
    @<%= plural_name %>.stub!(:get).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to save the <%= human_name.downcase %>" do
    @<%= name %>.should_receive(:update_attributes).with(attributes)
    do_update
  end
  
  it "should redirect to the <%= human_name.downcase %> if successful" do
    do_update.should redirect_to("/<%= plural_parent %>/1/<%= plural_name %>/2")
  end
  
  it "should render the form if the <%= human_name.downcase %> can't be saved" do
    @<%= name %>.stub!(:update_attributes).and_return(false)
    do_update do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
  
  it "should assign the <%= human_name.downcase %> to the view" do
    do_update.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should assign the country to the view" do
    do_update.assigns(:country).should == @country
  end
end

describe <%= controller_name %>, 'destroy' do
  before :each do
    @<%= parent %> = <%= parent_class_name %>.new(:id => "1")
    <%= parent_class_name %>.stub!(:get).with("1").and_return(@<%= parent %>)
    
    @<%= plural_name %> = mock("<%= plural_name %>")
    @<%= parent %>.stub!(:<%= plural_name %>).and_return(@<%= plural_name %>)
  
    @<%= name %> = <%= class_name %>.new(:id => "2")
    @<%= plural_name %>.stub!(:get).and_return(@<%= name %>)
    
    @<%= name %>.stub!(:destroy).and_return(true)
  end
  
  it "should have a route from /<%= plural_parent %>/1/<%= plural_name %>/2 DELETE" do
    request_to("/<%= plural_parent %>/1/<%= plural_name %>/2", :delete).should route_to(<%= controller_name %>, :destroy)
  end
  
  def do_delete
    dispatch_to(<%= controller_name %>, :destroy, :<%= parent %>_id => 1, :id => 2) do |controller|
      yield controller if block_given?
    end
  end
  
  it "should get the <%= parent %> from the database" do
    <%= parent_class_name %>.should_receive(:get).with("1").and_return(@<%= parent %>)
    do_delete
  end
  
  it "should raise NotFound if the <%= parent %> isn't found" do
    <%= parent_class_name %>.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the <%= human_name.downcase %> from the database" do
    @<%= parent %>.should_receive(:<%= plural_name %>).and_return(@<%= plural_name %>)
    @<%= plural_name %>.should_receive(:get).and_return(@<%= name %>)
    do_delete
  end
  
  it "should raise NotFound if the <%= human_name.downcase %> isn't found" do
    @<%= plural_name %>.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to delete the <%= human_name.downcase %>" do
    @<%= name %>.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the <%= human_name.downcase %>s list if destroyed" do
    do_delete.should redirect_to("/<%= plural_parent %>/1/<%= plural_name %>")
  end
  
  it "should raise InternalServerError if failed" do
    @<%= name %>.stub!(:destroy).and_return(false)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::InternalServerError)
  end
end