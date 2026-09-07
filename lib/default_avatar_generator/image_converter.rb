# frozen_string_literal: true

require 'open3'

module DefaultAvatarGenerator
  # Converts SVG to other image formats
  class ImageConverter
    def self.svg_to_jpeg(svg_content)
      # libvips's SVG loader is marked "untrusted" (it relies on rsvg's unfuzzed parser),
      # and apps that load Active Storage disable all untrusted vips operations globally
      # via Vips.block_untrusted(true) -- see https://github.com/rails/rails/pull/49236.
      # That blocks svgload/svgload_buffer even for content we generated ourselves, so we
      # rasterize with the rsvg-convert CLI instead, then hand vips a (trusted) PNG.
      png_bytes = svg_to_png(svg_content)

      image = Vips::Image.new_from_buffer(png_bytes, '')
      image = image.colourspace('srgb')
      image.jpegsave_buffer(Q: 90)
    end

    def self.svg_to_png(svg_content)
      png_bytes, stderr, status = Open3.capture3(
        'rsvg-convert', '-f', 'png', stdin_data: svg_content, binmode: true
      )
      raise Error, "rsvg-convert failed: #{stderr}" unless status.success?

      png_bytes
    rescue Errno::ENOENT
      raise Error, 'rsvg-convert executable not found. Install librsvg (e.g. librsvg2-bin on Debian/Ubuntu).'
    end
    private_class_method :svg_to_png
  end
end
