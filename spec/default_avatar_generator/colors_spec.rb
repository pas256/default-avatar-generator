# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator::Colors do
  def valid_colors_for(shades_method)
    described_class::COLORS.values.flat_map do |shades|
      described_class.send(shades_method).map { |s| shades[s] }
    end
  end

  describe '.select_solid_color' do
    it 'returns a hex color from the solid shades' do
      color = described_class.select_solid_color
      valid_colors = valid_colors_for(:solid_shades)
      expect(valid_colors).to include(color)
      expect(color).to match(/^#[0-9a-f]{6}$/i)
    end
  end

  describe '.select_contrast_color' do
    it 'returns a hex color from the contrast shades' do
      color = described_class.select_contrast_color
      valid_colors = valid_colors_for(:contrast_shades)
      expect(valid_colors).to include(color)
      expect(color).to match(/^#[0-9a-f]{6}$/i)
    end
  end

  describe '.opposite_shade' do
    it 'returns the correct opposite for given shades' do
      expect(described_class.opposite_shade(50)).to eq(950)
      expect(described_class.opposite_shade(300)).to eq(700)
      expect(described_class.opposite_shade(500)).to eq(500)
      expect(described_class.opposite_shade(900)).to eq(100)
    end
  end
end
