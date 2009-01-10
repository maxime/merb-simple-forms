# make sure we're running inside Merb
if defined?(Merb::Plugins)
  require File.join(File.dirname(__FILE__), "merb-simple-forms", "controls")
  require File.join(File.dirname(__FILE__), "merb-simple-forms", "link_helper")
  require File.join(File.dirname(__FILE__), "merb-simple-forms", "size_helpers")
  require File.join(File.dirname(__FILE__), "merb-simple-forms", "negative_captcha")
  require File.join(File.dirname(__FILE__), "merb-simple-forms", "simple-forms-helpers")
  require File.join(File.dirname(__FILE__), "merb-simple-forms", "identify")  

  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
end