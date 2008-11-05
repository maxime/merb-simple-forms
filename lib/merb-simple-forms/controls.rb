module Merb
  module Helpers
    module SimpleFormsHelpers
      module Controls
        def render_control(object, object_symbol, attribute, values)
          id = (object_symbol==nil) ? attribute.to_s : "#{object_symbol}_#{attribute}"
          name = (object_symbol==nil) ? attribute.to_s : "#{object_symbol}[#{attribute}]"

          label = values[:label] || humanize_symbol(attribute)
          # check if the object is here and the method is public
          value = (object==nil) ? nil : (object.public_methods.include?(attribute.to_s) ? object.send(attribute) : nil)
          collection = values[:collection]
          
          html = ''
          if self.respond_to?("control_#{values[:control]}")
            html = self.send("control_#{values[:control]}", {:id => id, :name => name, :value => value, :collection => collection})    
          else
            html = "unknown control #{values[:control].inspect}"
          end
          
          error_message = ""

          if object!=nil and object.errors and object.errors.on(attribute) and object.errors.on(attribute).size > 0
            object.errors.on(attribute).each do |error|
              error_message << tag(:div, error)
            end
            error_message = tag(:div, error_message, :class => 'errors')
          end

          html = tag(:label, label+":", :for => id) + html
          tag(:div, html, :class => "row #{values[:control]}") + error_message
        end
        
        def control_text_field(options={})
          text_field(options)
        end
        
        alias_method :control_text, :control_text_field
        
        def control_text_area(options={})
          text_area(options[:value], options)
        end
        
        alias_method :control_textarea, :control_text_area
        
        def control_password_field(options={})
          password_field(options)
        end
        
        alias_method :control_password, :control_password_field
        
        def control_file_field(options={})
          file_field(options)
        end
        
        alias_method :control_file, :control_file_field
        
        def control_select(options={})
          options[:selected] = options.delete(:value)
          select(options)
        end
        
        # Controls a computer size in bytes, KB, MB, GB and TB
        def control_size(options={})
          # Here is the javascript that does the conversion
          javascript_lib = <<JS
          <script type="text/javascript" charset="utf-8">
          function initialize_size_field(id) {
            $("#"+id+"_converted").bind('change', function() { update_size_field_value(id) });
            $("#"+id+"_unit").bind('change', function() { update_size_field_value(id) });
          }

          function update_size_field_value(id) {
            var converted_value = $("#"+id+"_converted").val();
            var unit = $("#"+id+"_unit").val();
            var hidden_field = $("#"+id);
            if (unit=="B") { hidden_field.val(converted_value); }
            if (unit=="KB") { hidden_field.val(converted_value * 1024); }
            if (unit=="MB") { hidden_field.val(converted_value * 1024 * 1024); }
            if (unit=="GB") { hidden_field.val(converted_value * 1024 * 1024 * 1024); }
            if (unit=="TB") { hidden_field.val(converted_value * 1024 * 1024 * 1024 * 1024); }  
          </script>
JS
          html = ""
          if options[:value] != nil
            size = Kernel.Float(options[:value])
            case
              when size.to_i == 1; unit = "B"; converted_value = 1;
              when size < 1.kilobyte; unit = "B"; converted_value = size;
              when size < 1.megabyte; unit = "KB"; converted_value = (size / 1.0.kilobyte);
              when size < 1.gigabyte; unit = "MB"; converted_value = (size / 1.0.megabyte);
              when size < 1.terabyte; unit = "GB"; converted_value = (size / 1.0.gigabyte);
              else                    unit = "TB"; converted_value = (size / 1.0.terabyte);
            end
          else
            converted_value = nil
            unit = "MB"
          end
          html << text_field(:id => options[:id]+"_converted", :name => options[:name]+"[converted]", :value => converted_value, :size => 10, :class => 'size')
          html << select(:id => options[:id]+"_unit", :name => options[:name]+"[unit]", :collection => [["B", "B"], ["KB", "KB"], ["MB", "MB"], ["GB", "GB"], ["TB", "TB"]], :selected => unit)
          html << hidden_field(options)
          # This javascript looks at the _converted text field and unit select and updates the real value in the hidden field 
          html << javascript_lib
          html << document_ready("initialize_size_field('#{options[:id]}');")
          html
        end
        
        def control_date_picker(options={})
          # format the date for the date picker (dm does the conversion in the other way just fine)
          options[:value] = options[:value].strftime("%m/%d/%Y") if options[:value].class == Time
          
          html = text_field(options)
          html << document_ready("$('##{options[:id]}').datepicker();")
          html
        end
        
        alias_method :control_date, :control_date_picker
        alias_method :control_date_selector, :control_date_picker        
      
        def control_time_picker(options={})
          # format the time for the date picker (dm does the conversion in the other way just fine)
          options[:value] = options[:value].strftime("%I:%M%p").downcase if options[:value].class == Time
          
          html = text_field(options)
          html << document_ready("$('##{options[:id]}').timepicker();")
          html          
        end
        
        alias_method :control_time, :control_time_picker
        alias_method :control_time_selector, :control_time_picker        
      
        def control_date_and_time(options={})
          date_picker = control_date_picker(options.merge(:id => options[:id]+"_date", :name => nil))
          time_picker = control_time_picker(options.merge(:id => options[:id]+"_time", :name => nil))
          hidden_field = hidden_field(options)
          
          javascript = <<JAVASCRIPT
            function update_date_and_time(id) {
              console.log("update date and time id: "+id);
              console.log("date is "+$("#"+id+"_date").val());
              console.log("time is "+$("#"+id+"_time").val());
              $("#"+id).val($("#"+id+"_date").val() + " " + $("#"+id+"_time").val());
            }
            
            $("##{options[:id]}_date").bind('change', function() { update_date_and_time('#{options[:id]}') });
            $("##{options[:id]}_time").bind('change', function() { update_date_and_time('#{options[:id]}') });
            $("#h_#{options[:id]}_time").bind('change', function() { update_date_and_time('#{options[:id]}') });
            $("#m_#{options[:id]}_time").bind('change', function() { update_date_and_time('#{options[:id]}') });
            $("#p_#{options[:id]}_time").bind('change', function() { update_date_and_time('#{options[:id]}') });
JAVASCRIPT
          
          date_picker + time_picker + hidden_field + document_ready(javascript)
        end
        
        alias_method :control_date_and_time_picker, :control_date_and_time
        alias_method :control_date_and_time_selector, :control_date_and_time
      
        def document_ready(script)
          "<script type=\"text/javascript\" charset=\"utf-8\">$(document).ready(function(){ #{script} } );</script>"
        end
      end
    end
  end
end