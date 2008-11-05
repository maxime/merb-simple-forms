module Merb
  module <%= controller_name %>Helper
    def <%= name %>_form_definition
      {:attributes => [ 
          <%=
            controls = []
            attributes.each_pair do |key, value|
              controls << "{:#{key} => {:control => :#{default_control(value)}}}"
            end
            controls.join(",\n\t\t\t\t\t") + "\n"
          -%>
        ]
      }
    end
  end
end # Merb