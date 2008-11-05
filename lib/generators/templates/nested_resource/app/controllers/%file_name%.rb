class <%= controller_name %> < Application
  before :get_<%= parent %>
  # provides :xml, :yaml, :js

  def index
    @<%= plural_name %> = @<%= parent %>.<%= plural_name %>
    display @<%= plural_name %>
  end

  def show(id)
    @<%= name %> = @<%= parent %>.<%= plural_name %>.get(id)
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
    @<%= name %> = @<%= parent %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    display @<%= name %>, :form
  end

  def create(<%= name %>)
    @<%= name %> = <%= class_name %>.new(<%= name %>)
    @<%= name %>.<%= parent %> = @<%= parent %>
    if @<%= name %>.save
      redirect resource(@<%= parent %>, @<%= name %>), :message => {:notice => "<%= human_name %> was successfully created"}
    else
      message[:error] = "<%= human_name %> failed to be created"
      render :form
    end
  end

  def update(id, <%= name %>)
    @<%= name %> = @<%= parent %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    if @<%= name %>.update_attributes(<%= name %>)
      redirect resource(@<%= parent %>, @<%= name %>)
    else
      display @<%= name %>, :form
    end
  end

  def destroy(id)
    @<%= name %> = @<%= parent %>.<%= plural_name %>.get(id)
    raise NotFound unless @<%= name %>
    if @<%= name %>.destroy
      redirect url(:<%= parent %>_<%= plural_name %>, @<%= parent %>)
    else
      raise InternalServerError
    end
  end
  
  protected
  
  def get_<%= parent %>
    @<%= parent %> = <%= parent_class_name %>.get(params[:<%= parent %>_id])
    raise NotFound unless @<%= parent %>
  end

end # <%= controller_name %>
