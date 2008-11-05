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
    
    def default_control(type)
      mapping = { "String" => 'text',
                  "Integer" => 'text',
                  "DateTime" => 'date_picker',
                  "Time" => 'date_picker',
                  "Text" => 'text_area'}
      raise "Not Supported type #{type.to_s}" if mapping[type.to_s] == nil
      return mapping[type.to_s]
    end
    
    def default_control_for_spec(type)
      mapping = { "String" => [:input, {:type => 'text'}],
                  "Integer" => [:input, {:type => 'text'}],
                  "DateTime" => [:input, {:type => 'text'}],
                  "Time" => [:input, {:type => 'text'}],
                  "Text" =>  [:textarea]}
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
        
        unless content =~ Regexp.new("^\s*#{to_inject}")
          content = content.gsub(/Merb::Router\.prepare\ do(\n[\s\t]*#\ RESTful\ routes)?/mi) do |match|
            "#{match}\n  #{to_inject}"
          end
          
          File.open(router_path, 'wb') { |file| file.write(content) }
          
          # successfuly added the route
          add_message "resources :#{plural_resource} route added to config/router.rb"
        else
          # already found the route
          add_message "resources :#{plural_resource} route already added to config/router.rb"
        end
      else
        # can't find the router.rb file
        add_message "you might need to add the '#{to_inject}' route to your router"
      end
    end
  end
end