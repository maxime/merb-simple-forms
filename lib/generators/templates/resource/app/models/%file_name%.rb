class <%= class_name %>
  include DataMapper::Resource
  
  property :id, Serial
<% attributes.each_pair do |key,value| -%>
  property :<%= key %>, <%= value %>
<% end -%>
end