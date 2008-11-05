class <%= controller_name %> < Application
  # provides :xml, :yaml, :js

  def index
    @<%= plural_name %> = <%= class_name %>.all
    display @<%= plural_name %>
  end

  def show(id)
    @<%= name %> = <%= class_name %>.get(id)
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
    @<%= name %> = <%= class_name %>.get(id)
    raise NotFound unless @<%= name %>
    display @<%= name %>, :form
  end

  def create(<%= name %>)
    @<%= name %> = <%= class_name %>.new(<%= name %>)
    if @<%= name %>.save
      redirect resource(@<%= name %>), :message => {:notice => "<%= class_name %> was successfully created"}
    else
      message[:error] = "<%= class_name %> failed to be created"
      display @<%= name %>, :form
    end
  end

  def update(id, <%= name %>)
    @<%= name %> = <%= class_name %>.get(id)
    raise NotFound unless @<%= name %>
    if @<%= name %>.update_attributes(<%= name %>)
      redirect resource(@<%= name %>)
    else
      display @<%= name %>, :form
    end
  end

  def destroy(id)
    @<%= name %> = <%= class_name %>.get(id)
    raise NotFound unless @<%= name %>
    if @<%= name %>.destroy
      redirect resource(:<%= plural_name %>)
    else
      raise InternalServerError
    end
  end
end # <%= controller_name %>
