# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator::ImageConverter do
  describe '.svg_to_jpeg' do
    let(:svg_content) do
      <<~SVG
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
          <rect width="512" height="512" fill="#ff0000"/>
        </svg>
      SVG
    end

    it 'converts SVG to JPEG bytes' do
      jpeg_bytes = described_class.svg_to_jpeg(svg_content)

      # Check that we got some bytes back
      expect(jpeg_bytes).to be_a(String)
      expect(jpeg_bytes.bytesize).to be > 0

      # Verify it's a JPEG by checking the magic bytes
      expect(jpeg_bytes.bytes[0..1]).to eq([0xFF, 0xD8]) # JPEG start marker
      expect(jpeg_bytes.bytes[-2..]).to eq([0xFF, 0xD9]) # JPEG end marker
    end
  end
end
