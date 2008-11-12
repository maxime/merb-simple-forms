module Merb
  module Helpers
    module LinkHelper
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
    end
  end
end

Merb::Controller.send(:include, Merb::Helpers::LinkHelper)