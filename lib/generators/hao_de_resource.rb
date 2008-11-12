require File.join(File.dirname(__FILE__), 'hao_de_generator')

module Merb::Generators

  class HaoDeResource < HaoDeGenerator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'resource')
    end
    
    desc <<-DESC
      Generates a hao de resource.
    DESC
    
    first_argument :name, :required => true, :desc => "resource name (singular)"
    second_argument :attributes, :as => :hash, :default => {}, :desc => "comma separated resource model properties in form of name:Class. Example: state:String"
    
    template :model do |template|
      template.source = "app/models/%file_name%.rb"
      template.destination = "app/models/#{name}.rb"
    end
    
    template :model_spec do |template|
      template.source = "spec/models/%file_name%_spec.rb"
      template.destination = "spec/models/#{name}_spec.rb"
    end
    
    template :helper do |template|
      template.source = "app/helpers/%file_name%.rb"
      template.destination = "app/helpers/#{name.pluralize}_helper.rb"
    end
    
    invoke :hao_de_layout do |generator|
      generator.new(destination_root, options)
    end

    template :controller do |template|
      template.source = "app/controllers/%file_name%.rb"
      template.destination = "app/controllers/#{name.pluralize}.rb"
      
      add_resource_route(plural_name)
      add_menu_tab
    end
    
    template :controller_spec do |template|
      template.source = "spec/controllers/%file_name%_spec.rb"
      template.destination = "spec/controllers/#{name.pluralize}_spec.rb"
    end
    
    [:index, :show, :form].each do |view|
      # The view by itself
      template view do |template|
        template.source = "app/views/%file_name%/#{view}.html.haml"
        template.destination = "app/views/#{name.pluralize}/#{view}.html.haml"
      end
      
      # The view specs
      template view do |template|
        template.source = "spec/views/%file_name%/#{view}.html.haml_spec.rb"
        template.destination = "spec/views/#{name.pluralize}/#{view}.html.haml_spec.rb"
      end
    end
    
    invoke :hao_de_layout do |generator|
      generator.new(destination_root, options)
    end
  end
  
  add :hao_de_resource, HaoDeResource
end