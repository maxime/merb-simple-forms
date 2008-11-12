require File.join(File.dirname(__FILE__), 'hao_de_generator')

module Merb::Generators

  class HaoDeLayout < HaoDeGenerator
    @@after_generation_messages = []
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'layout')
    end
    
    desc <<-DESC
      Generates a hao de layout.
    DESC
    
    template :layout do |template|
      template.source = "application.html.haml"
      template.destination = "app/views/layout/application.html.haml"
    end
    
    template :menu do |template|
      template.source = "_menu.html.haml"
      template.destination = "app/views/layout/_menu.html.haml"
      create_menu_items_helper
      use_haml_template_engine
    end    
    
    def use_haml_template_engine
      # use_template_engine :haml
      init_path = Merb.root + "/config/init.rb"
      if File.exists?(init_path)
        content = File.read(init_path)
        
        if ((content =~ /use_template_engine\s+:haml/)==nil) and (content =~ /use_template_engine\s+:erb/)
          content.gsub!(/use_template_engine\s+:erb/, 'use_template_engine :haml')
          File.open(init_path, 'wb') { |file| file.write(content) }
          add_message "now uses haml as a template engine"
        end
      end
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
    
    invoke :hao_de_javascripts do |generator|
      generator.new(destination_root, options)
    end
    
    invoke :hao_de_stylesheet do |generator|
      generator.new(destination_root, options)
    end
  end
  
  add :hao_de_layout, HaoDeLayout
end