require File.dirname(__FILE__) + '/../spec_helper'

describe <%= controller_name %>, "index action" do
  before :each do
    @<%= plural_name %> = mock('<%= plural_name %>')
    <%= class_name %>.stub!(:all).and_return(@<%= plural_name %>)
  end
  
  def do_index
    dispatch_to(<%= controller_name %>, :index) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /<%= plural_name %> GET" do
    request_to('/<%= plural_name %>', :get).should route_to(<%= controller_name %>, :index)
  end
  
  it "should be successful" do
    do_index.should be_successful
  end
  
  it "should get the <%= plural_human_name %> from the database" do
    <%= class_name %>.should_receive(:all).with(no_args).and_return(@<%= plural_name %>)
    do_index
  end
  
  it "should render the <%= plural_human_name %>" do
    do_index do |controller|
      controller.should_receive(:display).with(@<%= plural_name %>)
    end
  end
  
  it "should assign the <%= plural_human_name %> to the view" do
    do_index.assigns(:<%= plural_name %>).should == @<%= plural_name %>
  end
end

describe <%= controller_name %>, "show action" do
  before :each do
    @<%= name %> = mock('<%= name %>')
    <%= class_name %>.stub!(:get).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_name %>/1 GET" do
    request_to('/<%= plural_name %>/1', :get).should route_to(<%= controller_name %>, :show)
  end
  
  def do_show
    dispatch_to(<%= controller_name %>, :show, :id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_show.should be_successful
  end
  
  it "should get the <%= human_name %> from the database" do
    <%= class_name %>.should_receive(:get).with("1").and_return(@<%= name %>)
    do_show
  end
  
  it "should raise NotFound if the <%= human_name %> isn't found" do
    <%= class_name %>.stub!(:get).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the <%= human_name %> for the view" do
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
    @<%= name %> = mock("<%= name %>")
    <%= class_name %>.stub!(:new).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_name %>/new GET" do
    request_to("/<%= plural_name %>/new", :get).should route_to(<%= controller_name %>, :new)
  end
  
  def do_new
    dispatch_to(<%= controller_name %>, :new) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_new.should be_successful
  end
  
  it "should create a new <%= human_name %> object" do
    <%= class_name %>.should_receive(:new).with(no_args).and_return(@<%= name %>)
    do_new
  end
  
  it "should assigns the <%= human_name %> object for the view" do
    do_new.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should render the <%= human_name %>" do
    do_new do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
end

describe <%= controller_name %>, "edit action" do
  before :each do
    @<%= name %> = mock("<%= name %>")
    <%= class_name %>.stub!(:get).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_name %>/1/edit GET" do
    request_to("/<%= plural_name %>/1/edit", :get).should route_to(<%= controller_name %>, :edit)
  end
  
  def do_edit
    dispatch_to(<%= controller_name %>, :edit, :id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_edit.should be_successful
  end
  
  it "should get the <%= human_name %> object" do
    <%= class_name %>.should_receive(:get).with("1").and_return(@<%= name %>)
    do_edit
  end
  
  it "should raise NotFound if the <%= human_name %> object isn't found" do
    <%= class_name %>.stub!(:get).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the <%= human_name %> object for the view" do
    do_edit.assigns(:<%= name %>).should == @<%= name %>
  end
  
  it "should render the <%= human_name %>" do
    do_edit do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
end

describe <%= controller_name %>, 'create action' do
  before :each do
    @<%= name %> = <%= class_name %>.new
    @<%= name %>.stub!(:save).and_return(true)
    @<%= name %>.stub!(:id).and_return(1)
    
    <%= class_name %>.stub!(:new).and_return(@<%= name %>)
  end
  
  it "should have a route from /<%= plural_name %> POST" do
    request_to("/<%= plural_name %>", :post).should route_to(<%= controller_name %>, :create)
  end
  
  def attributes
    {"name" => "some name"}
  end
  
  def do_create
    dispatch_to(<%= controller_name %>, :create, :<%= name %> => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should create a new <%= human_name %> object" do
    <%= class_name %>.should_receive(:new).with(attributes).and_return(@<%= name %>)
    do_create
  end
  
  it "should try to save the <%= human_name %>" do
    @<%= name %>.should_receive(:save).with(no_args)
    do_create
  end
  
  it "should redirect to the newly created <%= human_name %> if successful" do
    do_create.should redirect_to(resource(@<%= name %>), :message => {:notice => "<%= human_name %> was successfully created"})
  end
  
  it "should render the form if not successful" do
    @<%= name %>.stub!(:save).and_return(false)
    do_create do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
  
  it "should assign the <%= human_name %> to the view" do
    do_create.assigns(:<%= name %>).should == @<%= name %>
  end
end

describe <%= controller_name %>, 'update' do
  before :each do
    @<%= name %> = <%= class_name %>.new(:id => "1")
    <%= class_name %>.stub!(:get).and_return(@<%= name %>)
    
    @<%= name %>.stub!(:update_attributes).and_return(true)
  end
  
  it "should have a route from /<%= plural_name %>/1 PUT" do
    request_to("/<%= plural_name %>/1", :put).should route_to(<%= controller_name %>, :update)
  end
  
  def attributes
    {"name" => "some name"}
  end
  
  def do_update
    dispatch_to(<%= controller_name %>, :update, :id => 1, :<%= name %> => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the <%= human_name %> from the database" do
    <%= class_name %>.should_receive(:get).and_return(@<%= name %>)
    do_update
  end
  
  it "should raise NotFound if the <%= human_name %> isn't found" do
    <%= class_name %>.stub!(:get).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to save the <%= human_name %>" do
    @<%= name %>.should_receive(:update_attributes).with(attributes)
    do_update
  end
  
  it "should redirect to the <%= human_name %> if successful" do
    do_update.should redirect_to("/<%= plural_name %>/1")
  end
  
  it "should render the form if the <%= human_name %> can't be saved" do
    @<%= name %>.stub!(:update_attributes).and_return(false)
    do_update do |controller|
      controller.should_receive(:display).with(@<%= name %>, :form)
    end
  end
  
  it "should assign the <%= human_name %> to the view" do
    do_update.assigns(:<%= name %>).should == @<%= name %>
  end
end

describe <%= controller_name %>, 'destroy' do
  before :each do
    @<%= name %> = <%= class_name %>.new(:id => "1")
    <%= class_name %>.stub!(:get).and_return(@<%= name %>)
    
    @<%= name %>.stub!(:destroy).and_return(true)
  end
  
  it "should have a route from /<%= plural_name %>/1 DELETE" do
    request_to("/<%= plural_name %>/1", :delete).should route_to(<%= controller_name %>, :destroy)
  end
  
  def do_delete
    dispatch_to(<%= controller_name %>, :destroy, :id => 1) do |controller|
      yield controller if block_given?
    end
  end
  
  it "should get the <%= human_name %> from the database" do
    <%= class_name %>.should_receive(:get).and_return(@<%= name %>)
    do_delete
  end
  
  it "should raise NotFound if the <%= human_name %> isn't found" do
    <%= class_name %>.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to delete the <%= human_name %>" do
    @<%= name %>.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the <%= plural_human_name %> list if destroyed" do
    do_delete.should redirect_to("/<%= plural_name %>")
  end
  
  it "should raise InternalServerError if failed" do
    @<%= name %>.stub!(:destroy).and_return(false)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::InternalServerError)
  end
end