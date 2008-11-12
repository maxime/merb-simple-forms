class <%= class_name %>
  include DataMapper::Resource
  
  property :id, Serial
<% attributes.each_pair do |key,value| -%>
  property :<%= key %>, <%= value %>
<% end -%>

<% parents.each do |parent| -%>
  belongs_to :<%= parent %>
<% end -%>
end