if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependencies 'merb-slices'
  dependencies 'merb-helpers'
  Merb::Plugins.add_rakefiles "merb-ui/merbtasks", "merb-ui/slicetasks", "merb-ui/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb-ui
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_ui][:layout] ||= :application
  
  # All Slice code is expected to be namespaced inside a module
  module MerbUi
    
    # Slice metadata
    self.description = "Merb UI"
    self.version = "1.0"
    self.author = "UI Poet"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbUi)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_ui_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match('/stylesheets/mui.css').to(:controller => 'styles', :action => 'index')
    end
    
  end
  
  # Setup the slice layout for MerbUi
  #
  # Use MerbUi.push_path and MerbUi.push_app_path
  # to set paths to merb-ui-level and app-level paths. Example:
  #
  # MerbUi.push_path(:application, MerbUi.root)
  # MerbUi.push_app_path(:application, Merb.root / 'slices' / 'merb-ui')
  # ...
  #
  # Any component path that hasn't been set will default to MerbUi.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbUi.setup_default_structure!
  
  # Add dependencies for other MerbUi classes below. Example:
  # dependency "merb-ui/other"
  
end