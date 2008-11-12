require File.join(File.dirname(__FILE__), 'hao_de_generator')

module Merb::Generators

  class HaoDeResourcePlusNested < HaoDeGenerator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'resource_plus_nested')
    end
        
    desc <<-DESC
      Generates a hao de resource that is also nested.
    DESC
    
    first_argument :name, :required => true, :desc => "nested resource name (singular)"
    second_argument :parent, :required => true, :desc => "parent resource name (singular)"
    third_argument :attributes, :as => :hash, :default => {}, :desc => "space separated resource model properties in form of name:type. Example: state:string"
    
    # template :model do |template|
    #   template.source = "app/models/%file_name%.rb"
    #   template.destination = "app/models/#{name}.rb"
    # 
    #   add_has_n_association_to_parent
    # end
    # 
    # template :model_spec do |template|
    #   template.source = "spec/models/%file_name%_spec.rb"
    #   template.destination = "spec/models/#{name}_spec.rb"
    # end
    # 
    # template :controller do |template|
    #   template.source = "app/controllers/%file_name%.rb"
    #   template.destination = "app/controllers/#{plural_name}.rb"
    #   
    #   add_nested_route
    # end
    # 
    # template :controller_spec do |template|
    #   template.source = "spec/controllers/%file_name%_spec.rb"
    #   template.destination = "spec/controllers/#{plural_name}_spec.rb"
    #   add_nested_resource_index_link_to_parent_show
    # end
    # 
    # template :helper do |template|
    #   template.source = "app/helpers/%file_name%.rb"
    #   template.destination = "app/helpers/#{plural_name}_helper.rb"
    # end
    # 
    # [:index, :show, :form].each do |view|
    #   # The view
    #   template "#{view}_view".intern do |template|
    #     template.source = "app/views/%file_name%/#{view}.html.haml"
    #     template.destination = "app/views/#{plural_name}/#{view}.html.haml"
    #   end
    #   
    #   # The view spec
    #   template "#{view}_view_spec".intern do |template|
    #     template.source = "spec/views/%file_name%/#{view}.html.haml_spec.rb"
    #     template.destination = "spec/views/#{plural_name}/#{view}.html.haml_spec.rb"
    #   end
    # end
    # 
    # invoke :hao_de_layout do |generator|
    #   generator.new(destination_root, options)
    # end
    
  end
  
  add :hao_de_resource_plus_nested, HaoDeResourcePlusNested
end