# frozen_string_literal: true

require 'tempfile'

module DefaultAvatarGenerator
  # Converts SVG to other image formats
  class ImageConverter
    def self.svg_to_jpeg(svg_content)
      # Create a temporary file to store the SVG
      temp_svg = Tempfile.new(['avatar', '.svg'])
      begin
        temp_svg.write(svg_content)
        temp_svg.close

        # Load the SVG using vips and convert to JPEG
        image = Vips::Image.new_from_file(temp_svg.path)

        # Convert to sRGB color space and save as JPEG to memory
        image = image.colourspace('srgb')
        image.jpegsave_buffer(Q: 90)
      ensure
        # Clean up temporary file
        temp_svg.unlink
      end
    end
  end
end
