require File.join(File.dirname(__FILE__), 'hao_de_generator')

module Merb::Generators

  class HaoDeNestedResource < HaoDeGenerator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'nested_resource')
    end
    
    desc <<-DESC
      Generates a hao de nested resource.
    DESC
    
    first_argument :name, :required => true, :desc => "nested resource name (singular)"
    second_argument :parent, :required => true, :desc => "parent resource name (singular)"
    third_argument :attributes, :as => :hash, :default => {}, :desc => "space separated resource model properties in form of name:type. Example: state:string"
    
    template :model do |template|
      template.source = "app/models/%file_name%.rb"
      template.destination = "app/models/#{name}.rb"

      add_has_n_association_to_parent
    end
    
    template :model_spec do |template|
      template.source = "spec/models/%file_name%_spec.rb"
      template.destination = "spec/models/#{name}_spec.rb"
    end
    
    template :controller do |template|
      template.source = "app/controllers/%file_name%.rb"
      template.destination = "app/controllers/#{plural_name}.rb"
      
      add_nested_route
    end
    
    template :controller_spec do |template|
      template.source = "spec/controllers/%file_name%_spec.rb"
      template.destination = "spec/controllers/#{plural_name}_spec.rb"
    end
    
    template :helper do |template|
      template.source = "app/helpers/%file_name%.rb"
      template.destination = "app/helpers/#{plural_name}_helper.rb"
    end
    
    [:index, :show, :form].each do |view|
      # The view
      template "#{view}_view".intern do |template|
        template.source = "app/views/%file_name%/#{view}.html.haml"
        template.destination = "app/views/#{plural_name}/#{view}.html.haml"
      end
      
      # The view spec
      template "#{view}_view_spec".intern do |template|
        template.source = "spec/views/%file_name%/#{view}.html.haml_spec.rb"
        template.destination = "spec/views/#{plural_name}/#{view}.html.haml_spec.rb"
      end
    end
    
    def human_parent_name
      Extlib::Inflection.humanize(parent)
    end
    
    def parent_class_name
      parent.gsub('-', '_').camel_case
    end
    
    def plural_parent
      parent.pluralize
    end
    alias_method :plural_parent_name, :plural_parent
    
    def add_has_n_association_to_parent
      model_path = Merb.root + "/app/models/#{parent}.rb"
      to_inject = "has n, :#{plural_name}"
      if File.exist?(model_path)
        content = File.read(model_path)
        
        unless content =~ Regexp.new("^[\s\t]*#{to_inject}")
          content = content.gsub(/end\s*\n*\Z/mi) {|match| "\n  #{to_inject}\n#{match}"}
          
          File.open(model_path, 'wb') { |file| file.write(content) }
          
          add_message "#{to_inject} added to the #{parent}.rb model"
        else
          add_message "sounds like the associaton #{to_inject} is already defined in #{parent}.rb"
        end
      else
        add_message "you might need to add the association #{to_inject} to your #{parent_class_name} model"
      end
    end
    
    def add_nested_route
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
          
          block_content = content.gsub(/\A.*\n[\s\t]+resources :toys do(.*?)end.*\Z/mi, '\1')
          # check whether the route is already defined
          if block_content =~ /^[\s\t]*resources :#{plural_name}/
            add_message "sounds like the resources :#{plural_name} is already defined into the resources :#{plural_parent} block"
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
        add_message "resources :#{plural_name} added to the resources :#{plural_parent} block in config/router.rb"
      else
        add_message "you might need to add the nested route for this new resource"
      end
    end
  end
  
  add :hao_de_nested_resource, HaoDeNestedResource
end