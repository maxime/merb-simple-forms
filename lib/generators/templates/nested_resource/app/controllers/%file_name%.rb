class <%= controller_name %> < Application
<% if single_parent? -%>
  before :get_<%= parent %>
<% else -%>
  before :get_parent
<% end -%>
  # provides :xml, :yaml, :js

  def index
    @<%= plural_name %> = <%= parent_instance_variable_name %>.<%= plural_name %>
    display @<%= plural_name %>
  end

  def show(id)
    @<%= name %> = <%= parent_instance_variable_name %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    display @<%= name %>
  end

  def new
    only_provides :html
    @<%= name %> = <%= class_name %>.new
    display @<%= name %>, :form
  end

  def edit(id)
    only_provides :html
    @<%= name %> = <%= parent_instance_variable_name %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    display @<%= name %>, :form
  end

  def create(<%= name %>)
    @<%= name %> = <%= class_name %>.new(<%= name %>)
<% if single_parent? -%>
    @<%= name %>.<%= parent %> = <%= parent_instance_variable_name %>
<% else -%>
<% parents.each do |parent| -%>
    @<%= name %>.<%= parent %> = <%= parent_instance_variable_name %> if params[:<%= parent %>_id]
<% end -%>
<% end -%>
    if @<%= name %>.save
      redirect resource(<%= parent_instance_variable_name %>, @<%= name %>), :message => {:notice => "<%= human_name %> was successfully created"}
    else
      message[:error] = "<%= human_name %> failed to be created"
      render :form
    end
  end

  def update(id, <%= name %>)
    @<%= name %> = <%= parent_instance_variable_name %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    if @<%= name %>.update_attributes(<%= name %>)
      redirect resource(<%= parent_instance_variable_name %>, @<%= name %>)
    else
      display @<%= name %>, :form
    end
  end

  def destroy(id)
    @<%= name %> = <%= parent_instance_variable_name %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    if @<%= name %>.destroy
      redirect resource(<%= parent_instance_variable_name %>, :<%= plural_name %>)
    else
      raise InternalServerError
    end
  end
  
  protected
  
<% if single_parent? -%>
  def get_<%= parent %>
    @<%= parent %> = <%= parent_class_name %>.get(params[:<%= parent %>_id])
    raise NotFound unless @<%= parent %>
  end
<% else -%>
  def get_parent
<% parents.each do |parent| -%>
    @parent = <%= classify_name(parent) %>.get(params[:<%= parent %>_id]) if params[:<%= parent %>_id]
<% end -%>
    raise NotFound unless @parent
  end
<% end -%>
end # <%= controller_name %>
