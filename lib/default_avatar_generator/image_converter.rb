# frozen_string_literal: true

module DefaultAvatarGenerator
  # Converts SVG to other image formats
  class ImageConverter
    def self.svg_to_jpeg(svg_content)
      # Load the SVG directly from memory and convert to JPEG. Avoids round-tripping
      # through a temp file, which intermittently failed in production with
      # "is not a known file format" when the file wasn't fully flushed/visible yet.
      image = Vips::Image.new_from_buffer(svg_content, '')

      # Convert to sRGB color space and save as JPEG to memory
      image = image.colourspace('srgb')
      image.jpegsave_buffer(Q: 90)
    end
  end
end
