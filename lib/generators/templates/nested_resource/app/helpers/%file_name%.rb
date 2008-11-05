module Merb
  module <%= controller_name %>Helper
    def <%= name %>_form_definition
      {:attributes => [ 
          <%=
            controls = []
            form_attributes.each_pair do |key, value|
              controls << "{:#{key} => {:control => :#{default_control(value)}}}"
            end
            #controls << "{:#{parent}_id => {:control => :select, :label => '#{human_parent_name}', :collection => #{parent_class_name}.all.collect{|#{parent}| [\"toy: \#\{#{parent}.id\}\", #{parent}.id]}}}"
            controls.join(",\n\t\t\t\t\t") + "\n"
          -%>
        ],
       :nested_within => :<%= parent %>
      }
    end
  end
end # Merb