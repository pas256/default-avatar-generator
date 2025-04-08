# frozen_string_literal: true

module DefaultAvatarGenerator
  # Utility methods for SVG manipulation
  module SvgUtils
    module_function

    def minify(svg)
      svg.gsub(/>\s+</, '><').gsub(/\s+/, ' ').strip
    end
  end
end
