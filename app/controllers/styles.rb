class MerbUi::Styles < MerbUi::Application

  only_provides :css

  def index
    if mui_browser == 'gecko'
      @browser = selector('*::-moz-focus-inner') do
        property('border', :value => 'none')
        property('padding', :value => 0)
      end
    elsif mui_browser == 'msie'
      @browser = selector('*.mui_button') do
        property('overflow', :value => 'visible')
        property('width', :value => 'auto')
      end
    end
    render :layout => false
  end
    
  Merb::BootLoader.after_app_loads do
    Merb.add_mime_type(:css, :to_css, %w[text/css])
  end
    
end