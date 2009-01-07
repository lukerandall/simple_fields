module SimpleFields
  # Contains the helpers used for the simple_fields plugin. Really the only thing
  # you'll be calling is field, which needs to be feed a field_name, and optionally
  # a field type, a label to override the default, and an HTML class
  module SimpleFieldHelpers
    # Generates a label, field, description and tooltip for the specified attribute.
    # Specify +field_type+ if you need something other than a text field, +label+ to override
    # the default label, and +class+ to provide an HTML class.
    # The description and explanation lookup uses the I18n gem (which ships with Rails >= 2.2)
    def field(field_name, options = {})
      options.reverse_merge! :field_type => :text_field, :label => nil, :class => nil
      key = "#{self.object_name}_#{field_name}_description".to_sym
      html = []
      html << "<p>"
      html << "\n"
      html << self.label(*(options[:label] ? [field_name, options[:label]] : [field_name]))
      html << "\n"
      html << self.send(options[:field_type], field_name, :class => options[:class])
      html << tooltip(field_name)
      html << "\n"
      html << @template.content_tag(:span, @template.t(key), :class => 'description') if localization_exists(key)
      html << "\n"
      html << "</p>"
      html << "\n"
      html
    end

    # Looks for a localized explanation matching +field_name+, and creates a tooltip with the
    # explanation if it finds one
    def tooltip(field_name)
      field = "#{self.object_name}_#{field_name}".to_sym
      key = "#{field}_explanation".to_sym
      return unless localization_exists(key)
      link = "#{field}_link"
      explanation = key.to_s
      html = []
      html << @template.link_to(@template.image_tag('explanation.png', :class => 'explanation'), '#', :id => link)
      html << "\n"
      html << @template.content_tag(:span, @template.textilize_without_paragraph(@template.t(key)), :class => 'tooltip', :id => explanation)
      html << "\n"
      html << "<script type=\"text/javascript\">"
      html << "\n"
      html << "  var #{explanation}_tooltip = new Tooltip('#{link}', '#{explanation}')"
      html << "\n"
      html << "</script>"
      html << "\n"
    end

    # Determines if a localized string for +key+ exists
    def localization_exists(key)
      @template.t(key) != '-Needs definition-'
    end
  end
end