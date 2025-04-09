# frozen_string_literal: true

module DefaultAvatarGenerator
  # Text SVG layer
  class TextLayer < Layer
    private

    def template_path
      File.join(__dir__, '..', 'assets', 'text', "#{template_name}.svg")
    end
  end
end
