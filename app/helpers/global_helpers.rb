module Merb::GlobalHelpers
  
  def mui_bar(options = {}, &block)
    @@mui_bar_tab_width = options[:tab_width] if options[:tab_width]
    tag(:div, capture(&block), :class => 'mui_bar')
  end
  
  def mui_block(options = {}, &block)
    attributes = {}
    attributes[:align] = options[:align] if options[:align]
    attributes[:class] = 'mui_block'
    if type = options[:type]
      if type == 'inline'
        tag_type = :span
      else
        tag_type = :div
        attributes[:class] << %{ mui_block_#{type}}
      end
    else
      tag_type = :div
    end
    if options[:height] || options[:width]
      attributes[:style] = ''
      attributes[:style] << %{height:#{options[:height]};} if options[:height]
      attributes[:style] << %{width:#{options[:width]};} if options[:width]
    end
    content = ''
    content << mui_title(:title => options[:title], :title_size => options[:title_size]) if options[:title]
    content << capture(&block) if block_given?
    tag(tag_type, content, attributes)
  end
  
  def mui_body(options = {}, &block)
    attributes={}
    attributes[:class] = 'mui_desktop'
    attributes[:class] << ' mui_gallery' if controller_name == 'merb_photos/photos'
    output = ''
    if message = session[:mui_message]
      message_content = mui_button(:title => '&#215;', :message => 'close')
      message_content << message[:title] if message[:title]
      message_content << message[:body] if message[:body]
      output << tag(:div, message_content, :class => %{mui_message mui_message_#{message[:tone]}})
      session.delete(:mui_message)
    end
    output << capture(&block)
    copyright_now = Time.now.year
    copyright_then = MerbUi[:year] || copyright_now
    if copyright_now == copyright_then
      copyright_years = copyright_now
    else
      copyright_years = %{#{copyright_then}-#{copyright_now}}
    end
    copyright_owner = %{ #{MerbUi[:owner]}} if MerbUi[:owner]
    copyright_text = %{Copyright &copy; #{copyright_years}#{copyright_owner}. All Rights Reserved.}
    copyright = tag(:div, copyright_text, :class => 'mui_copyright')
    output << tag(:div, catch_content(:for_layout) + copyright, attributes)
    output << tag(:div, :class => 'mui_window_target')
    if session[:mui_window]
      output << tag(:script, "windowOpen('#{session[:mui_window]}');", :type => 'text/javascript')    	
      session.delete(:mui_window)
    end
    output
  end
  
  def mui_browser
    browser = request.user_agent
    if browser.include? 'MSIE'
      'msie'
    elsif browser.include? 'Gecko/'
      'gecko'
    elsif browser.include? 'AppleWebKit'
      'webkit'
    else
      'unknown'
    end
  end

  def mui_button(options = {}, &block)
    attributes = {}
    attributes[:class] = 'mui_button'
    attributes[:class] << %{ mui_button_tone_#{options[:tone] || 'neutral'}}
    attributes[:class] << ' mui_click'
    attributes[:class] << %{_message_#{options[:message]}} if options[:message]
    attributes[:class] << %{_window_#{options[:window]}} if options[:window]
    attributes[:id] = options[:url] if options[:url]
    attributes[:name] = options[:name] if options[:name]
    attributes[:style] = %{width:#{options[:width]};} if options[:width]
    attributes[:type] = options[:submit] == true ? 'submit' : 'button'
    attributes[:value] = options[:title] if options[:title]
    if block_given?
      if options[:title]
        content = tag(:table, tag(:tr, tag(:td, capture(&block)) + tag(:td, options[:title], :width => '100%')))
      else
        content = capture(&block)
      end
      tag(:button, content, attributes)
    else
      self_closing_tag(:input, attributes)
    end
  end
  
  def mui_cell(options = {}, &block)
    return unless block_given?
    @mui_grid[:count] += 1
    attributes = {}
    attributes[:align] = @mui_grid[:align] || options[:align] || nil
    attributes[:nowrap] = 'nowrap' if options[:wrap] == false
    if options[:width]
      attributes[:style] = %{width:#{options[:width]}}
    else
      attributes[:style] = %{width:#{@mui_grid[:width]}} if @mui_grid[:width]
    end
    attributes[:valign] = @mui_grid[:valign] || options[:valign] || 'top'
    html = ''
    if @mui_grid[:count] > @mui_grid[:columns]
      @mui_grid[:count] = 0
      html << close_tag(:tr) + open_tag(:tr)
    end
    html << tag(:td, capture(&block), attributes)
  end

  def mui_check(name, options = {})
    columns = tag(:td, check_box(name, :class => 'mui_check'))
    columns << tag(:td, tag(:label, options[:title]))
    tag(:table, tag(:tr, columns))
  end
  
  def mui_date(name, options = {})
    tag(:div, date_field(name, :label => options[:title]), :class => 'mui_date')
  end
  
  def mui_date_span(options = {})
    tag(:span, relative_date_span([options[:created], options[:updated]]), :class => 'mui_date')
  end
  
  def mui_delete(options = {})
    attributes = {}
    attributes[:class] = 'mui_button mui_button_tone_negative'
    attributes[:style] = %{width:#{options[:width]};} if options[:width]
    delete_button(options[:url], options[:title], attributes)
  end
  
  def mui_divider
    tag(:hr, :class => 'mui_divider')
  end

  def mui_form(name, options = {}, &block)
    form_for(name, options, &block)
  end

  def mui_grid(options = {}, &block)
    return unless block_given?
    mui_grid_temp = @mui_grid if @mui_grid
    @mui_grid = {}
    @mui_grid[:align] = options[:cell_align]
    @mui_grid[:count] = 0
    @mui_grid[:columns] = options[:columns] || 1
    @mui_grid[:valign] = options[:cell_valign]
    @mui_grid[:width] = options[:cell_width]
    attributes = {}
    attributes[:class] = 'mui_grid'
    attributes[:style] = %{width:#{options[:width]}} if options[:width]
    html = tag(:table, tag(:tr, capture(&block)), attributes)
    @mui_grid = mui_grid_temp if mui_grid_temp
    html
  end
  
  def mui_head
    path = '/slices/merb-ui/javascripts/'
    require_css('master', 'mui')
    require_js('jquery', "#{path}ui", "#{path}dimensions", "#{path}keybinder", "#{path}desktop")
    include_required_css + include_required_js + catch_content(:feeds)
  end
  
  def mui_hyper_text(name, options = {})
    attributes = {}
    attributes[:class] = 'mui_hyper_text'
    attributes[:class] << ' mui_focus' if options[:focus] == true
    attributes[:label] = options[:title]
    text_area(name, attributes)
  end

  def mui_image(options={})
    attributes={}
    attributes[:align] = options[:align] if options[:align]
    attributes[:class] = 'mui_image'
    attributes[:class] << ' mui_image_border' if options[:border] == true
    if options[:height] && options[:width]
      attributes[:class] << ' mui_image_rounded' if options[:rounded] == true
      attributes[:src] = '/slices/merb-ui/images/nil.png'
      attributes[:style] = %{background-image: url('#{options[:url]}');}
      attributes[:style] << %{height: #{options[:height]}px;}
      attributes[:style] << %{width: #{options[:width]}px;}
    else
      attributes[:src] = file
    end
    attributes[:class] << ' mui_photo' if options[:photo] == true
    attributes[:class] << ' mui_inline' if options[:inline] == true
    self_closing_tag(:img, attributes)
  end
  
  def mui_link(options={}, &block)
    attributes = {}
    attributes[:class] = 'mui_link'
    attributes[:href] = options[:url]
    if block_given?
      content = capture(&block)
      attributes[:title] = options[:title]
    else
      content = options[:title]
    end
    attributes[:style] = %{font-size:#{options[:title_size]};} if options[:title_size]
    tag(:a, content, attributes)
  end

  def mui_list(parents = [])
    children = ''
    parents.each do |p|
      p.each do |c|
        children << tag(:li, c, :class => 'mui_list_item')
      end
    end
    tag(:ul, children, :class => 'mui_list')
  end
  
  def mui_paragraph(options={}, &block)
    tag(:p, (capture(&block) if block_given?), :class => 'mui_paragraph')
  end

  def mui_password(name, options = {})
    attributes = {}
    attributes[:class] = 'mui_password'
    attributes[:class] << ' mui_focus' if options[:focus] == true
    attributes[:label] = options[:title]
    password_field(name, attributes)
  end
  
  def mui_search(options = {})
    attributes = {}
    attributes[:class] = 'mui_search'
    attributes[:name] = :search
    attributes[:style] = %{width:#{options[:width]};} if options[:width]
    attributes[:type] = :text
    attributes[:value] = params[:search]
    box = mui_cell(:valign => 'middle'){tag(:input, attributes)}
    button =  mui_cell(:align => 'right', :valign => 'middle', :wrap => false){%{#{mui_button(:submit => true, :title => 'Search')}}}
    table = mui_grid(:columns => 2){box + button}
    tag(:form, table, :action => options[:action])
  end
  
  def mui_tab(options = {}, &block)
    attributes = {}
    attributes[:class] = 'mui_tab'
    attributes[:class] << ' mui_selected' if options[:controller] == controller_name || options[:selected] == true
    attributes[:href] = options[:url] if options[:url]
    if options[:width]
      attributes[:style] = %{width:#{options[:width]}}
    elsif @@mui_bar_tab_width
      attributes[:style] = %{width:#{@@mui_bar_tab_width}}
    end
    tag(:a, options[:title], attributes)
  end

  def mui_text(name, options = {})
    attributes = {}
    attributes[:class] = 'mui_text'
    attributes[:class] << ' mui_focus' if options[:focus] == true
    attributes[:label] = options[:title]
    attributes[:maxlength] = options[:length] || 50
    attributes[:style] = %{width:#{options[:width]};} if options[:width]
    text_field(name, attributes)
  end
  
  def mui_title(options = {})
    size = options[:title_size] || '1.5em'
    attributes = {}
    attributes[:class] = 'mui_title'
    attributes
    attributes[:style] = %{font-size:#{size}}
    tag(:div, options[:title], attributes)
  end
  
  def mui_window(options = {}, &block)
    script = js_include_tag '/slices/merb-ui/javascripts/window'
    bar_content = ''
    bar_content << tag(:td, options[:buttons], :class => 'mui_bar_buttons') if options[:buttons]
    bar_content << tag(:td, options[:title], :class => 'mui_window_title') if options[:title]
    bar_content << tag(:td, mui_button(:title => '&#215;', :window => 'close'), :class => 'mui_window_bar_end')
    bar = tag(:tr, tag(:td, tag(:table, tag(:tr, bar_content), :class => 'mui_window_bar')))
    content = tag(:tr, tag(:td, capture(&block), :class => 'mui_window_content'))
    script + tag(:table, bar + content, :class => 'mui_window')
  end

  def mui_window_redirect
    url = session[:mui_referer] || '/'
    session.delete(:mui_referer)
    redirect(url)
  end
  
  def mui_window_referer
    session[:mui_referer] = request.referer
  end

end