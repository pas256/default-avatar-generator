# frozen_string_literal: true

module DefaultAvatarGenerator
  # Background SVG layer
  class BackgroundLayer < Layer
    private

    def template_path
      File.join(__dir__, '..', 'assets', 'backgrounds', "#{template_name}.svg")
    end
  end
end
