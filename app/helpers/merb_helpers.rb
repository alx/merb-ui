module Merb::Helpers::Form
  def date_field(*args)
    if bound?(*args)
      current_form_context.bound_date_field(*args)
    else
      current_form_context.unbound_date_field(*args)
    end
  end
end
 
module Merb::Helpers::Form::Builder
  class Base
    def bound_date_field(method, attrs = {})
      name = control_name(method)
      update_bound_controls(method, attrs, "text")
      unbound_date_field({:name => name, :value => @obj.send(method)}.merge(attrs))
    end
 
    def unbound_date_field(attrs)
      update_unbound_controls(attrs, "date")
      if attrs[:name] =~ /\[(.*)\]/
        date = @obj.send($1)
      end
      date = DateTime::now() if date.nil?
      
      month_attrs = attrs.merge(
        :class        => "date month",
        :selected     => date.month,
        :name         => attrs[:name] + '[month]',
        :id           => attrs[:id] + '_month',
        :collection   => (1..12).map{|i|[i, DateTime::MONTHNAMES[i]]}
      )
      
      day_attrs = attrs.merge(
        :class        => "date day",
        :selected     => date.day.to_s,
        :name         => attrs[:name] + '[day]',
        :id           => attrs[:id] + '_day',
        :collection   => (1..31).map{|i|i.to_s},
        :label        => nil
      )
      
      year_attrs = attrs.merge(
        :class        => "date year",
        :selected     => date.year.to_s,
        :name         => attrs[:name] + '[year]',
        :id           => attrs[:id] + '_year',
        :collection   => (1900..Time.now.year).map{|i|i.to_s}.reverse,
        :label        => nil
      )
      
      unbound_select(month_attrs) + unbound_select(day_attrs) + unbound_select(year_attrs)
    end
    
  end
end