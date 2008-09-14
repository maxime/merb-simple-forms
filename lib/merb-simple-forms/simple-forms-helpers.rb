module Merb
  module Helpers
    module SimpleFormsHelpers
      # helpers defined here available to all views.  
      def link(content="link", options={})
        options.merge!(:to => '#', :method => :get) unless options[:to]
        to = options.delete(:to)
        if to.class == Symbol
          to = (to == :back) ? request.env["HTTP_REFERER"] : url(to)
        end 
        method = options[:method]
        confirm = options.delete(:confirm)
        if method and method != :get
          options[:onclick] ||= ""
          if confirm
            options[:onclick] += "if (confirm('#{h(confirm)}')) { " + javascript_for_method(method) + "}"
          else
            options[:onclick] += javascript_for_method(method)
          end
          options[:onclick] += "; return false;"
        end

        if options[:to_function]
          to_function = options.delete(:to_function)
          tag :a, content, options.update(:onclick => "#{to_function}; return false;", :href => to)
        else
          tag :a, content, options.update(:href => to)
        end  
      end

      def javascript_for_method(method)
        "var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href; var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', '#{method}'); f.appendChild(m);f.submit();"
      end

      def render_basic_form(form_definition)
        render_form(form_definition[:model_name], form_definition)
      end

      def render_form(object_symbol, form_definition={})
        object = (object_symbol==nil) ? nil : self.instance_variable_get("@#{object_symbol.to_s}")

        if ((form_definition=={}) and (object!=nil))
          form_definition = object.class.form_definition
        end

        form = "\n"
        method = form_definition[:method] || ((object==nil) ? :post : (object.new_record? ? :post : :put))
        if (method!=:post and method!=:get)
          form << hidden_field(:name => '_method', :value => method)
          form << "\n"
        end
        attributes = form_definition[:attributes] || object.class.form_definition[:attributes]
        if attributes
          attributes.each do |h|
            attribute = h.keys.first
            hash =  h[attribute]
            form << "\n"
            form << render_control(object, object_symbol, attribute, hash)
          end
        end

        submit = "\n"
        submit << submit((object == nil) ? 'Submit' : (object.new_record? ? "Create" : "Update"))

        namespace = form_definition[:namespace] ? form_definition[:namespace].to_s : nil

        cancel_url = form_definition[:cancel_url]

        if cancel_url.nil? && object_symbol
          if namespace.nil? || namespace.empty?
            cancel_url = url("#{object_symbol.to_s.pluralize}")
          else
            cancel_url = url("#{namespace}_#{object_symbol.to_s.pluralize}")
          end        
        end

        if (cancel_url!=nil)
          submit << " or "
          submit << link("Cancel", :to => cancel_url) 
        end

        submit << "\n"
        form << tag(:div, submit, :class => 'submit')

        action = form_definition[:action] || ((object==nil) ? '#' : action(object, form_definition[:nested_within], form_definition[:route_name], namespace, form_definition[:disable_slug]))

        form = tag(:form, form, :method => (method==:get ? :get : :post), :action => action, :enctype => (form_definition[:multipart] ? 'multipart/form-data' : nil))

        tag(:div, "\n#{form}\n", :class => 'form')
      end

      def render_control(object, object_symbol, attribute, values)
        id = (object_symbol==nil) ? attribute.to_s : "#{object_symbol}_#{attribute}"
        name = (object_symbol==nil) ? attribute.to_s : "#{object_symbol}[#{attribute}]"
        basic_attributes = {:id => id, :name => name}

        label = values[:label] || humanize_symbol(attribute)
        value = (object==nil) ? '' : object.send(attribute)
        html = ''    
        case values[:control]
          when :text_field, :text
            html = text_field(basic_attributes.update(:value => value))
          when :text_area
            html = text_area(value, basic_attributes)
          when :password_field, :password
            html = password_field(basic_attributes.update(:value => value))
          when :file_field, :file
            html = file_field(basic_attributes)
          when :select
            html = select(basic_attributes.update(:collection => values[:collection], :selected => value))
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

      def humanize_symbol(object)
        object.to_s.gsub(/_/, ' ').capitalize
      end

      def action(object, nested_within, route_name, namespace, disable_slug)
        route_name ||= object.class.storage_name

        if nested_within
          parent = self.instance_variable_get("@#{nested_within.to_s}")
          if object.new_record?
            if namespace
              url("#{namespace}_#{nested_within}_#{route_name}".intern, (nested_within.to_s.singularize + "_id").intern => ( (parent.respond_to?(:slug) && !disable_slug)  ? parent.slug : parent.id))
            else
              url("#{nested_within}_#{route_name}".intern, (nested_within.to_s.singularize + "_id").intern => ((parent.respond_to?(:slug) && !disable_slug) ? parent.slug : parent.id))
            end
          end
        else
          if object.new_record?
            if namespace
              url("#{namespace}_#{route_name}".intern)
            else
              url(route_name.intern)
            end
          else
            if namespace
              url("#{namespace}_#{route_name.to_s.singularize}".intern, :id => ( (object.respond_to?(:slug)  && !disable_slug) ? object.slug : object.id))
            else
              url(route_name.to_s.singularize.intern, :id => ((object.respond_to?(:slug)  && !disable_slug) ? object.slug : object.id))
            end
          end
        end
      end
    end
  end
end