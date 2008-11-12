module Merb::Generators

  class HaoDeJavascripts < Generator
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'javascripts')
    end
    
    desc <<-DESC
      Generates hao de javascripts.
    DESC
    
    glob! "public/javascripts", []
  end
  
  add :hao_de_javascripts, HaoDeJavascripts
end