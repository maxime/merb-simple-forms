module Merb::Generators

  class HaoDeStylesheet < Generator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'stylesheet')
    end
    
    desc <<-DESC
      Generates a hao de stylesheet.
    DESC
    
    file :master_stylesheet do |stylesheet|
      stylesheet.source = File.join(source_root, "master.sass")
      stylesheet.destination = "public/stylesheets/sass/master.sass"
    end

    file :reset_stylesheet do |stylesheet|
      stylesheet.source = File.join(source_root, "reset.sass")
      stylesheet.destination = "public/stylesheets/sass/reset.sass"
    end
  end
  
  add :hao_de_stylesheet, HaoDeStylesheet
end