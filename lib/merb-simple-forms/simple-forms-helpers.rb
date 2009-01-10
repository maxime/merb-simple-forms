module Merb
  module Helpers
    module SimpleFormsHelpers
      include Merb::Helpers::SimpleFormsHelpers::Controls
      include Merb::NegativeCaptcha
      def render_basic_form(form_definition)
        render_form(form_definition[:model_name], form_definition)
      end

      def render_form(object_symbol, form_definition={})
        object = (object_symbol==nil) ? nil : self.instance_variable_get("@#{object_symbol.to_s}")

        if (form_definition=={})
          if (object!=nil) and object.class.respond_to?(:form_definition)
            form_definition = object.class.form_definition
          else
            form_definition = self.send(object_symbol.to_s+"_form_definition")
          end
        end
        
        self.negative_captcha_options = form_definition[:negative_captcha] 
        
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
            if hash[:explanation]
              form << "\n"
              form << tag(:div, hash[:explanation], :class => "explanation")
            end
          end
        end

        submit = "\n"
        submit << submit(form_definition[:submit] || ((object == nil) ? 'Submit' : (object.new_record? ? "Create" : "Update")))

        namespace = form_definition[:namespace] ? form_definition[:namespace].to_s : nil
        nested_within = form_definition[:nested_within] ? form_definition[:nested_within].to_s : nil
        parent = (self.instance_variable_get("@#{nested_within.singular.to_s}") || self.instance_variable_get("@parent")) if nested_within
        
        cancel_url = form_definition[:cancel_url]
        
        if cancel_url.nil? && object_symbol
          if namespace.nil? || namespace.empty?
            if nested_within and parent
              cancel_url = resource(parent, object_symbol.to_s.pluralize.intern)
            else
              cancel_url = url(object_symbol.to_s.pluralize.intern)
            end
          else
            if nested_within and parent
              cancel_url = url("#{namespace}_#{nested_within.singular}_#{object_symbol.to_s.pluralize}".intern, "#{nested_within.singular}_id".intern => parent_id)
            else
              cancel_url = url("#{namespace}_#{object_symbol.to_s.pluralize}".intern)
            end
          end        
        end

        if (cancel_url!=nil) && (cancel_url != false)
          submit << " or "
          submit << link("Cancel", :to => cancel_url) 
        end

        submit << "\n"
        form << tag(:div, submit, :class => 'submit')

        action = form_definition[:action] || ((object==nil) ? '#' : action(object, form_definition[:nested_within], form_definition[:route_name], namespace, form_definition[:disable_slug]))

        form = tag(:form, form, :method => (method==:get ? :get : :post), :action => action, :enctype => (form_definition[:multipart] ? 'multipart/form-data' : nil))

        tag(:div, "\n#{form}\n", :class => 'form')
      end

      def humanize_symbol(object)
        object.to_s.gsub(/_/, ' ').capitalize
      end

      def action(object, nested_within, route_name, namespace, disable_slug)
        if nested_within
          parent = self.instance_variable_get("@#{nested_within.to_s.singular}") || self.instance_variable_get("@parent")
          if object.new_record?
            route_name ||= object.class.storage_name
            if namespace
              url("#{namespace}_#{nested_within.singular}_#{route_name}".intern, (nested_within.to_s.singularize + "_id").intern => ( (parent.respond_to?(:slug) && !disable_slug)  ? parent.slug : parent.id))
            else
              resource(parent, route_name.intern)
            end
          else
            route_name ||= object.class.storage_name.singular
            if namespace
              url("#{namespace}_#{nested_within.singular}_#{route_name}".intern, (nested_within.to_s.singularize + "_id").intern => ( (parent.respond_to?(:slug) && !disable_slug)  ? parent.slug : parent.id), :id => ( (object.respond_to?(:slug)  && !disable_slug) ? object.slug : object.id))
            else
              resource(parent, object)
            end
          end
        else
          if object.new_record?
            route_name ||= object.class.storage_name
            if namespace
              url("#{namespace}_#{route_name}".intern)
            else
              url(route_name.intern)
            end
          else
            route_name ||= object.class.storage_name.singular
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

Merb::Controller.send(:include, Merb::Helpers::SimpleFormsHelpers)