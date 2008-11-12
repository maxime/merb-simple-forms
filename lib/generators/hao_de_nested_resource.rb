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
    second_argument :parents, :as => :array, :required => true, :desc => "comma separated parents resource names in singular. Example: article,product"
    third_argument :attributes, :as => :hash, :default => {}, :desc => "comma separated resource model properties in form of name:Class. Example: state:String"
    
    template :model do |template|
      template.source = "app/models/%file_name%.rb"
      template.destination = "app/models/#{name}.rb"

      parents.each do |parent|
        add_has_n_association_to(parent)
      end
    end
    
    template :model_spec do |template|
      template.source = "spec/models/%file_name%_spec.rb"
      template.destination = "spec/models/#{name}_spec.rb"
    end
    
    template :controller do |template|
      template.source = "app/controllers/%file_name%.rb"
      template.destination = "app/controllers/#{plural_name}.rb"
      
      parents.each do |parent|
        add_nested_route(parent)
      end
    end
    
    template :controller_spec do |template|
      if single_parent?
        template.source = "spec/controllers/%file_name%_spec_single_parent.rb"
        template.destination = "spec/controllers/#{plural_name}_spec.rb"
      else
        template.source = "spec/controllers/%file_name%_spec_multiple_parent.rb"
        template.destination = "spec/controllers/#{plural_name}_spec.rb"
      end

      parents.each do |parent|
        add_nested_resource_index_link_to_parent_show(parent)
      end
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
    
    invoke :hao_de_layout do |generator|
      generator.new(destination_root, options)
    end
  end
  
  add :hao_de_nested_resource, HaoDeNestedResource
end