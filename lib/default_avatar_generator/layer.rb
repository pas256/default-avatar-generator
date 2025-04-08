# frozen_string_literal: true

require 'nokogiri'

module DefaultAvatarGenerator
  # The Layer class is responsible for rendering SVG templates with given parameters.
  class Layer
    attr_reader :template_name, :params

    def initialize(template_name, params = {})
      @template_name = template_name
      @params = params
    end

    def render
      template = load_template
      process_template(template)
    end

    private

    def load_template
      # Load the SVG template file
      File.read(template_path)
    end

    def template_path
      # Implement in subclasses to define where templates are stored
      raise NotImplementedError, "#{self.class} must implement #template_path"
    end

    def process_template(template)
      # Replace only the parameters that exist in params
      parsed = template.gsub(/\{\{(\w+)\}\}/) do |match|
        param_name = ::Regexp.last_match(1)
        params.key?(param_name.to_sym) ? params[param_name.to_sym].to_s : match
      end

      # Parse the XML and extract just the first child element inside the svg tag
      doc = Nokogiri::XML(parsed)
      doc.at('svg > *').to_s
    end
  end
end
