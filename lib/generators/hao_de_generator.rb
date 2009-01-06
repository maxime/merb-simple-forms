require 'randexp'

module Merb::Generators

  class HaoDeGenerator < Generator
    @@after_generation_messages = []
        
    def class_name
      name.gsub('-', '_').camel_case
    end
    
    def controller_name
      class_name.pluralize
    end
    
    def plural_name
      name.pluralize
    end
    
    def human_name
      Extlib::Inflection.humanize(name)
    end
    
    def plural_human_name
      human_name.plural
    end
    
    def identifier
      attributes.keys.first.to_s
    end
    
    def default_control(type)
      mapping = { "String" => 'text',
                  "Integer" => 'text',
                  "DateTime" => 'date_picker',
                  "Time" => 'date_picker',
                  "Text" => 'text_area',
                  "Float" => 'text'}
      raise "Not Supported type #{type.to_s}" if mapping[type.to_s] == nil
      return mapping[type.to_s]
    end
    
    def default_control_for_spec(type)
      mapping = { "String" => [:input, {:type => 'text'}],
                  "Integer" => [:input, {:type => 'text'}],
                  "DateTime" => [:input, {:type => 'text'}],
                  "Time" => [:input, {:type => 'text'}],
                  "Text" =>  [:textarea],
                  "Float" => [:input, {:type => 'text'}]}
      raise "Not Supported type #{type.to_s}" if mapping[type.to_s] == nil
      return mapping[type.to_s]
    end
    
    def generate_for_type(type)
      case type
      when "Integer"
        /\d{1,3}/.gen.to_i
      when "Text"
        /[:sentence:]/.gen
      else
        /\w+/.gen
      end
    end
    
    def form_attributes
      output = attributes
      output.delete(:created_at)
      output.delete(:updated_at)
      output.delete(:id)      
      output
    end
    
    def generate_attributes
      hash = {:id => /\d{1}/.gen.to_i}
      attributes.each do |key, value|
        hash.merge!(key.intern => generate_for_type(value))
      end
      hash.inspect
    end
    
    def after_generation
      if @@after_generation_messages.size > 0
        @@after_generation_messages.each do |mess|
          STDOUT << message(mess)
        end
      end
    end
    
    def add_message(mess)
      @@after_generation_messages << mess
    end
    
    def add_resource_route(plural_resource)
      router_path = Merb.root + "/config/router.rb"
      to_inject = "resources :#{plural_resource}"
      if File.exist?(router_path)
        content = File.read(router_path)
        routes = content.gsub(/\A.*^\s*Merb::Router.prepare do\s+(.*)\s+end\s*\Z/mi, '\1')
        routes_without_nested_routes = routes.gsub(/do(.*?)end/mi, '') 
        
        if (routes_without_nested_routes =~ Regexp.new("^\s*#{to_inject}")) == nil
          content = content.gsub(/Merb::Router\.prepare\ do(\n[\s\t]*#\ RESTful\ routes)?/mi) do |match|
            "#{match}\n  #{to_inject}"
          end
          
          File.open(router_path, 'wb') { |file| file.write(content) }
          
          # successfuly added the route
          add_message "+ resources :#{plural_resource} route added to config/router.rb"
        else
          # already found the route
          add_message "  resources :#{plural_resource} route already added to config/router.rb"
        end
      else
        # can't find the router.rb file
        add_message "! you might need to add the '#{to_inject}' route to your router"
      end
    end
    
    def add_route(to_inject)
      router_path = Merb.root + "/config/router.rb"
      
      if File.exist?(router_path)
        content = File.read(router_path)
        
        unless content =~ Regexp.new("^\s*#{to_inject}")
          
          content.gsub!(/end\n*\s*\Z/mi) do |match|
            "\n  #{to_inject}\n#{match}"
          end
          
          File.open(router_path, 'wb') { |file| file.write(content) }
          
          # successfuly added the route
          add_message "+ #{to_inject} route added to config/router.rb"
        else
          # already found the route
          add_message "  #{to_inject} route already added to config/router.rb"
        end
      else
        # can't find the router.rb file
        add_message "! /config/router.rb not found - you might need to add '#{to_inject}' manually to your router."
      end
    end
    
    def create_menu_items_helper
      helper_path = Merb.root + "/app/helpers/global_helpers.rb"
      to_inject = <<RB
    def menu_items
      [
        ["Home", "/"]
      ]
    end
RB
      if File.exists?(helper_path)
        content = File.read(helper_path)
        unless content =~ /^\s*def\s*menu_items/i
          content = content.gsub(/\n\s*end\s*\n\s*end\s*\Z/mi) do |match|
            "\n#{to_inject}#{match}"
          end

          File.open(helper_path, 'wb') { |file| file.write(content) }

          add_message "+ menu_items method added to app/helpers/global_helpers.rb"
        end
      else
        add_message "! app/helpers/global_helpers.rb not found"
      end
    end
    
    def add_menu_tab
      helper_path = Merb.root + "/app/helpers/global_helpers.rb"
      if File.exists?(helper_path)
        content = File.read(helper_path)
        to_inject = ",\n        [\"#{plural_human_name}\", url(:#{plural_name})]"
        
        unless content =~ /^\s*def\s+menu_items/
          create_menu_items_helper
          content = File.read(helper_path)
        end

        tabs = content.gsub(/\A.*def\s+menu_items\n\s*(.*?)\n\s*end.*\Z/mi, '\1')
    
        if tabs.include?("url(:#{plural_name})") && tabs.include?(plural_human_name)
          # the tab has been found, not creating it again
          add_message "  the tab '#{plural_human_name}' already added to the tabs list"
        else
          # add the tab
          sentinel = /(def\s+menu_items\n\s*\[\n\s*)(.*?)(\n\s*\]\s*\n\s*end)/mi
          content = content.gsub(sentinel, '\1\2' + to_inject+'\3')
          File.open(helper_path, 'wb') { |file| file.write(content) }
          add_message "+ tab '#{plural_human_name}' added to the tabs list"
        end
      else
        add_message "! app/helpers/global_helpers.rb not found"
      end
    end
    
    def destination_root
      File.join(@destination_root)
    end
    
    def file_name
      name.snake_case
    end
    
    alias_method :base_name, :file_name
    
    # Nested shit:
    
    def single_parent?
      parents.size == 1
    end
    
    def parent_instance_variable_name
      single_parent? ? "@#{parent}" : "@parent"
    end
    
    # temporary
    def parent
      parents.first
    end
    
    def human_parent_name(parent=nil)
      parent ||= parents.first
      Extlib::Inflection.humanize(parent)
    end
    
    def parent_class_name(parent=nil)
      classify_name (parent ? parent : parents.first)
    end
    
    def classify_name(string)
      string.gsub('-', '_').camel_case
    end
    
    def parent_identifier(parent)
      # this is totally crazy. loading the parent model to get the properties and take the first one...
      require Merb.root + "/app/models/#{parent}.rb"
      Module.const_get(parent_class_name).properties.collect {|p| p.name }.delete_if {|e| e==:id}.first
    end
    
    def plural_parent(parent=nil)
      parent ||= parents.first
      parent.pluralize
    end
    alias_method :plural_parent_name, :plural_parent
    
    def add_has_n_association_to(parent)
      parent_class_name = classify_name(parent)
      model_path = Merb.root + "/app/models/#{parent}.rb"
      to_inject = "has n, :#{plural_name}"
      if File.exist?(model_path)
        content = File.read(model_path)
        
        unless content =~ Regexp.new("^[\s\t]*#{to_inject}")
          content = content.gsub(/end\s*\n*\Z/mi) {|match| "\n  #{to_inject}\n#{match}"}
          
          File.open(model_path, 'wb') { |file| file.write(content) }
          
          add_message "+ #{to_inject} added to the #{parent}.rb model"
        else
          add_message "  associaton #{to_inject} already defined in #{parent}.rb"
        end
      else
        add_message "! you might need to add the association #{to_inject} to your #{parent_class_name} model"
      end
    end
    
    def add_nested_route(parent)
      plural_parent = parent.pluralize
      router_path = Merb.root + "/config/router.rb"
      to_inject = "resources :#{plural_name}"
      
      if File.exist?(router_path)
        content = File.read(router_path)
        
        # if parent route isn't present, create it
        unless content =~ /^[\s\t]*resources :#{plural_parent}/
          add_resource_route(plural_parent)  
          # read the file again, because it might be changed
          content = File.read(router_path)
        end
        
        # two cases, whether the block around the parent route is open, whether it's not
        if content =~ /^[\s\t]*resources :#{plural_parent}[\s\t]+do/i
          # the block is open already...
          sentinel = /^[\s\t]*resources :#{plural_parent}[\s\t]+do/mi
          to_inject = "\n    #{to_inject}"
          
          block_content = content.gsub(/\A.*\n[\s\t]+resources :#{plural_parent} do(.*?)end.*\Z/mi, '\1')
          # check whether the route is already defined
          if block_content =~ /^[\s\t]*resources :#{plural_name}/
            add_message "  resources :#{plural_name} already defined into the resources :#{plural_parent} block"
            return
          end
        else
          # the block isn't open yet...
          sentinel = /^[\s\t]*resources :#{plural_parent}/mi
          to_inject = "\sdo\n    #{to_inject}\n  end\n"
        end
      
        content = content.gsub(sentinel) do |match|
          "#{match}#{to_inject}"
        end
        File.open(router_path, 'wb') { |file| file.write(content) }
        add_message "+ resources :#{plural_name} added to the resources :#{plural_parent} block in config/router.rb"
      else
        add_message "! you might need to add the nested route for this new resource"
      end
    end
    
    def add_nested_resource_index_link_to_parent_show(parent)
      plural_parent = parent.pluralize
      view_path = Merb.root + "/app/views/#{plural_parent}/show.html.haml"
      
      if File.exist?(view_path)
        content = File.read(view_path)

        to_inject = "\n%p= link '#{human_name.pluralize}', :to => url(:#{parent}_#{plural_name}, @#{parent}), :class => 'action view_children'"
                
        unless content.include?("url(:#{parent}_#{plural_name}, @#{parent})")
          # inject it at the end of the show view
          content += to_inject
          
          File.open(view_path, 'wb') { |file| file.write(content) }
        end
      end
    end
  end
end