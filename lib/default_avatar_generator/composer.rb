# frozen_string_literal: true

module DefaultAvatarGenerator
  # Composes all of the layers together into a single SVG
  class Composer
    def initialize(layers)
      @layers = layers
    end

    def compose
      SvgUtils.minify(<<~SVG)
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
          #{@layers.map(&:render).join("\n          ")}
        </svg>
      SVG
    end
  end
end
