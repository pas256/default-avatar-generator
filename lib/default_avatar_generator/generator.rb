# frozen_string_literal: true

module DefaultAvatarGenerator
  # The Generator class is responsible for creating avatar images with customizable
  # backgrounds, foregrounds, and text layers.
  class Generator
    AVAILABLE_BACKGROUNDS = %w[
      gradient-2h
      gradient-3h
      gradient-backslash
      gradient-slash
      gradient-lr
      gradient-tb
      solid
    ].freeze

    AVAILABLE_FOREGROUNDS = %w[
      head1-solid
      head2
      head3
    ].freeze

    # NOTE: 'base' doesn't work because libvips doesn't support `dominant-baseline` in SVG.
    # Can move back once https://gitlab.gnome.org/GNOME/librsvg/-/merge_requests/1072
    # makes it way into the latest version.
    AVAILABLE_TEXT = %w[
      hack
    ].freeze

    def initialize(options = {})
      @options = options
    end

    def generate # rubocop:disable Metrics/AbcSize
      # Create layers with dynamic parameters
      layers = [
        BackgroundLayer.new(
          select_background,
          background_params.merge(@options[:background] || {})
        ),
        ForegroundLayer.new(
          select_foreground,
          foreground_params.merge(@options[:foreground] || {})
        ),
        TextLayer.new(
          select_text,
          text_params.merge(@options[:text] || {})
        )
      ]

      Composer.new(layers).compose
    end

    def select_background
      AVAILABLE_BACKGROUNDS.sample
    end

    def background_params
      {
        color1: Colors.select_solid_color,
        color2: Colors.select_solid_color,
        color3: Colors.select_solid_color,
        color4: Colors.select_solid_color,
        color5: Colors.select_solid_color,
        color6: Colors.select_solid_color
      }
    end

    def select_foreground
      AVAILABLE_FOREGROUNDS.sample
    end

    def foreground_params
      @foreground_color_name = Colors.available_colors.sample
      @foreground_shade = Colors.contrast_shades.sample
      {
        color: Colors.get(@foreground_color_name, @foreground_shade),
        transformation: ForegroundLayer.select_transform
      }
    end

    def select_text
      AVAILABLE_TEXT.sample
    end

    def text_params
      {
        color: Colors.get(@foreground_color_name, Colors.opposite_shade(@foreground_shade))
        # character: ('A'..'Z').to_a.sample
      }
    end
  end
end
