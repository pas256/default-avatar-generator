# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator::Composer do
  let(:test_layer_class) do
    Class.new(DefaultAvatarGenerator::Layer) do
      def render
        "<test>#{params[:content]}</test>"
      end
    end
  end

  let(:layer1) { test_layer_class.new('test1', content: 'Layer 1') }
  let(:layer2) { test_layer_class.new('test2', content: 'Layer 2') }
  let(:composer) { described_class.new([layer1, layer2]) }

  describe '#compose' do
    it 'combines all layers into a single SVG' do
      expected = DefaultAvatarGenerator::SvgUtils.minify(<<~SVG)
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
          <test>Layer 1</test>
          <test>Layer 2</test>
        </svg>
      SVG
      expect(composer.compose).to eq(expected)
    end

    it 'works with no layers' do
      composer = described_class.new([])
      expected = DefaultAvatarGenerator::SvgUtils.minify(<<~SVG)
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
        </svg>
      SVG
      expect(composer.compose).to eq(expected)
    end
  end
end
