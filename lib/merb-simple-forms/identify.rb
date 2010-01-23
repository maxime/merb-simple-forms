module Merb
  module ModelInstanceIdentify
    def identify
      value = self.send(properties.collect {|p| p.serial? ? nil : p.name }.compact.first)
      if value == nil or (value.respond_to?(:empty?) and value.empty?)
        if new?
          return "new #{self.class.identify}"
        else
          return "#{self.class.identify} #{(self.respond_to?(:id) && self.id!=nil) ? "id:#{self.id}" : ''}"
        end
      end
      value
    end
  end

  module ClassIdentify
    def identify
      Extlib::Inflection.humanize(self.to_s)
    end
  end
end

module DataMapper
  module Resource
    include Merb::ModelInstanceIdentify
  end
end

class Class
  include Merb::ClassIdentify
end

class String
  def identify
    self
  end
end