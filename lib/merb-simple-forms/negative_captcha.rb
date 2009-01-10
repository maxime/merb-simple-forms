require 'md5'

module Merb
  module NegativeCaptcha
    def negative_control(control, options)
      html = ''
      unless @@negative_captcha_controls_delivered
        html << negative_captcha_controls
        @@negative_captcha_controls_delivered = true
      end
      
      options.delete(:id)
      control = control.to_s.gsub(/^negative_/, '')
      
      # honeypot
      html << far_away(self.send("control_#{control}", options.merge(:tabindex => '999', :value => nil)))
      
      # real control
      options[:name] = MD5.hexdigest([options[:name], negative_captcha_options[:spinner], negative_captcha_options[:secret], @@negative_captcha_timestamp]*'-')
      html << self.send("control_#{control}", options.merge(:tabindex => '1'))

      html
    end
    
    def far_away(something)
      "<div style='position: absolute; left: -3400px;'>#{something}</div>"
    end
    
    def negative_captcha_options=(options)
      @@negative_captcha_controls_delivered = false
      @@negative_captcha_options = options
    end
    
    def negative_captcha_options
      @@negative_captcha_options
    end
    
    def negative_captcha_controls
      @@negative_captcha_timestamp = Time.now.to_i
      hidden_field(:name => 'timestamp', :value => @@negative_captcha_timestamp) +
        hidden_field(:name => 'spinner', :value => negative_captcha_options[:spinner])
    end
    
    def negative_captcha_form?
      Merb::NegativeCaptcha.class_variables.include?("@@negative_captcha_options") && self.negative_captcha_options != nil
    end
    
    def negative_captcha_params(object_symbol)
      message = "Please try again."
      # Verify Timestamp
      if (!params[:timestamp]) || ((Time.now.to_i - params[:timestamp].to_i).abs > 1.day.to_i)
        raise Merb::ControllerExceptions::BadRequest, message
      end
      
      form_definition = self.send(object_symbol.to_s+"_form_definition")

      # Verify Spinner
      if params[:spinner] != form_definition[:negative_captcha][:spinner]
        raise Merb::ControllerExceptions::BadRequest, message
      end

      # Verify that the honeypots are empty
      form_definition[:attributes].each do |attribute|
        unless params[object_symbol][attribute.keys.first].empty?
          raise Merb::ControllerExceptions::BadRequest, message
        end
      end
      
      # Decrypt now
      values = {}
      form_definition[:attributes].each do |attribute|
        encrypted_control_name = MD5.hexdigest(["#{object_symbol}[#{attribute.keys.first}]", form_definition[:negative_captcha][:spinner], form_definition[:negative_captcha][:secret], params[:timestamp]]*'-')
        values[attribute.keys.first] = params[encrypted_control_name]
      end
      values
    end
  end
end