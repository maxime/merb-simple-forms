module Merb
  module ModelInstanceIdentify
    def identify
      value = self.send(properties.collect {|p| p.serial? ? nil : p.name }.compact.first)
      if value == nil or value.empty?
        if new_record?
          return "new #{Extlib::Inflection.humanize(self.class.to_s)}"
        else
          return "#{Extlib::Inflection.humanize(self.class.to_s)} #{(self.respond_to?(:id) && self.id!=nil) ? "id:#{self.id}" : ''}"
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

module DataMapper
  module Resource
    module ClassMethods
      include Merb::ClassIdentify
    end
  end
end
