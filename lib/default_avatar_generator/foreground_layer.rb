# frozen_string_literal: true

module DefaultAvatarGenerator
  # Foreground SVG layer
  class ForegroundLayer < Layer
    def self.select_transform
      ['', 'scale(-1, 1) translate(-512, 0)'].sample
    end

    private

    def template_path
      File.join(__dir__, '..', 'assets', 'foregrounds', "#{template_name}.svg")
    end
  end
end
