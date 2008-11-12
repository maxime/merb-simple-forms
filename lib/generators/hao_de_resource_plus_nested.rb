require File.join(File.dirname(__FILE__), 'hao_de_generator')

module Merb::Generators

  class HaoDeResourcePlusNested < HaoDeGenerator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end
        
    desc <<-DESC
      Generates a hao de resource that is also nested.
    DESC
    
    first_argument :name, :required => true, :desc => "nested resource name (singular)"
    second_argument :parents, :as => :array, :required => true, :desc => "parent resource name (singular)"
    third_argument :attributes, :as => :hash, :default => {}, :desc => "space separated resource model properties in form of name:type. Example: state:string"
    
    template :model do |template|
      template.source = "nested_resource/app/models/%file_name%.rb"
      template.destination = "app/models/#{name}.rb"

      parents.each do |parent|
        add_has_n_association_to(parent)
      end
    end
    
    
    template :model_spec do |template|
      template.source = "nested_resource/spec/models/%file_name%_spec.rb"
      template.destination = "spec/models/#{name}_spec.rb"
    end

    template :controller do |template|
      template.source = "resource_plus_nested/app/controllers/%file_name%.rb"
      template.destination = "app/controllers/#{plural_name}.rb"
      
      parents.each do |parent|
        add_nested_route(parent)
      end
    end
    
    template :controller_spec do |template|
      if single_parent?
        template.source = "resource_plus_nested/spec/controllers/%file_name%_spec_single_parent.rb"
        template.destination = "spec/controllers/#{plural_name}_spec.rb"
      else
        template.source = "resource_plus_nested/spec/controllers/%file_name%_spec_multiple_parent.rb"
        template.destination = "spec/controllers/#{plural_name}_spec.rb"
      end
      
      # Non-nested route
      add_resource_route(plural_name)

      # Nested routes
      parents.each do |parent|
        add_nested_resource_index_link_to_parent_show(parent)
      end
      
      # Add Menu Tab
      add_menu_tab
    end
    
    template :helper do |template|
      template.source = "nested_resource/app/helpers/%file_name%.rb"
      template.destination = "app/helpers/#{plural_name}_helper.rb"
    end
    
    
    [:index, :show, :form].each do |view|
      # The view
      template "#{view}_view".intern do |template|
        template.source = "resource_plus_nested/app/views/%file_name%/#{view}.html.haml"
        template.destination = "app/views/#{plural_name}/#{view}.html.haml"
      end
      
      # The view spec
      template "#{view}_view_spec".intern do |template|
        template.source = "resource_plus_nested/spec/views/%file_name%/#{view}.html.haml_spec.rb"
        template.destination = "spec/views/#{plural_name}/#{view}.html.haml_spec.rb"
      end
    end
    
    invoke :hao_de_layout do |generator|
      generator.new(destination_root, options)
    end
  end
  
  add :hao_de_resource_plus_nested, HaoDeResourcePlusNested
end