module Merb::MerbUi::StylesHelper

  def border_radius(options={})
    options[:amount] ||= 0.5
    if mui_browser == 'gecko'
      property('-moz') do
        property('border') do
          if options[:edge] == 'bottom'
            property('radius') do
              property('bottomleft', :value => %{#{options[:amount]}em})
              property('bottomright', :value => %{#{options[:amount]}em})
              property('topleft', :value => 0)
              property('topright', :value => 0)
            end
          elsif options[:edge] == 'top'
            property('radius') do
              property('bottomleft', :value => 0)
              property('bottomright', :value => 0)
              property('topleft', :value => %{#{options[:amount]}em})
              property('topright', :value => %{#{options[:amount]}em})
            end
          else
            property('radius', :value => %{#{options[:amount]}em})
          end
        end
      end
    elsif mui_browser == 'webkit'
      property('-webkit') do
        property('border') do
          if options[:edge] == 'bottom'
            property('bottom-left-radius', :value => %{#{options[:amount]}em})
            property('bottom-right-radius', :value => %{#{options[:amount]}em})
            property('top-left-radius', :value => 0)
            property('top-right-radius', :value => 0)
          elsif options[:edge] == 'top'
            property('bottom-left-radius', :value => 0)
            property('bottom-right-radius', :value => 0)
            property('top-left-radius', :value => %{#{options[:amount]}em})
            property('top-right-radius', :value => %{#{options[:amount]}em})
          else
            property('radius', :value => %{#{options[:amount]}em})
          end
        end
      end
    end
  end

  def color(r,g,b)
    %{rgb(#{decimal_to_rgb(r)}, #{decimal_to_rgb(g)}, #{decimal_to_rgb(b)})}
  end

  def decimal_to_rgb(d)
    (d * 255).to_i
  end

  def has_layout
    'min-height: 0;' if msie?
  end

  def property(property, options={})
    @parent ||= ''
    @child ||= ''
    if block_given?
      @child = nil
      @parent << %{#{property}-}
      yield
      @parent = nil
      @child
    elsif options[:value]
      @child << %{\r  #{@parent}#{property}: #{options[:value]};}
    end
  end

  def selector(selector)
    "#{selector} {#{yield}\r}\r"
  end

end