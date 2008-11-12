require File.join(File.dirname(__FILE__), 'hao_de_generator')

module Merb::Generators

  class HaoDeHomepage < HaoDeGenerator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'homepage')
    end
    
    desc <<-DESC
      Generates a hao de homepage.
    DESC
    
    file :controller do |file|
      file.source = "app/controllers/static_pages.rb"
      file.destination = "app/controllers/static_pages.rb"
    
      add_route("match('/').to(:controller => 'static_pages', :action =>'homepage')")
    end
    
    file :helper do |file|
      file.source = "app/helpers/static_pages_helper.rb"
      file.destination = "app/helpers/static_pages_helper.rb"
    end
    
    file :view do |file|
      file.source = "app/views/static_pages/homepage.html.haml"
      file.destination = "app/views/static_pages/homepage.html.haml"
    end

    file :controller_spec do |file|
      file.source = "spec/controllers/static_pages_spec.rb"
      file.destination = "spec/controllers/static_pages_spec.rb"
    end
    
    file :view_spec do |file|
      file.source = "spec/views/static_pages/homepage.html.haml_spec.rb"
      file.destination = "spec/views/static_pages/homepage.html.haml_spec.rb"
    end
    
    invoke :hao_de_layout do |generator|
      generator.new(destination_root, options)
    end
  end
  
  add :hao_de_homepage, HaoDeHomepage
end