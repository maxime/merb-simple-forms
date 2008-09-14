# make sure we're running inside Merb
if defined?(Merb::Plugins)
  Merb.logger.info "loading simple forms helpers"
  require Pathname(__FILE__).dirname.expand_path / 'merb-simple-forms' / 'simple-forms-helpers.rb'

  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
end