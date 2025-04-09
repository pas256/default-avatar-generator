# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator::SvgUtils do
  describe '.minify' do
    it 'removes unnecessary whitespace between tags' do
      input = <<~SVG
        <svg>
          <rect />
          <circle />
        </svg>
      SVG
      expect(described_class.minify(input)).to eq('<svg><rect /><circle /></svg>')
    end

    it 'removes all unnecessary whitespace' do
      expect(described_class.minify('<svg>  <rect    />  </svg>')).to eq('<svg><rect /></svg>')
    end

    it 'removes leading and trailing whitespace' do
      expect(described_class.minify("  \n<svg></svg>\n  ")).to eq('<svg></svg>')
    end
  end
end
